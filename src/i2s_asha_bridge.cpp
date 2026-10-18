
/*
 * WM8782S I2S input bridge for Pico-ASHA
 * =======================================
 *
 * Purpose:
 *   Adds an analog TV-audio input to Pico-ASHA using a WM8782S stereo ADC.
 *
 * Hardware:
 *   - Raspberry Pi Pico 2 W
 *   - WM8782S ADC board
 *   - ViO T33 6 Li hearing aids
 *
 * WM8782S configuration:
 *   - ADC is I2S controller/master
 *   - Pico is I2S target/slave
 *   - 96 kHz sample rate
 *   - 24-bit stereo audio
 *   - 32-bit I2S slots
 *   - External/onboard MCLK on the WM8782S board
 *
 * Wiring:
 *   WM8782S DATA  -> Pico GP2
 *   WM8782S BICK  -> Pico GP10
 *   WM8782S LRCK  -> Pico GP11
 *   WM8782S DGND  -> Pico GND
 *   WM8782S VCC   -> Pico VBUS / 5 V
 *
 * Audio processing:
 *
 *   WM8782S
 *      |
 *      | 96 kHz / 24-bit stereo I2S
 *      v
 *   Pico PIO
 *      |
 *      v
 *   DMA ping-pong buffers
 *      |
 *      v
 *   i2s_asha_bridge
 *      |
 *      | FIR low-pass + decimate by 2
 *      v
 *   48 kHz / 16-bit stereo PCM
 *      |
 *      v
 *   asha_audio_encode_1ms_pcm(..., 48)
 *      |
 *      | existing Pico-ASHA 48 -> 16 kHz processing
 *      v
 *   G.722
 *      |
 *      v
 *   ASHA / Bluetooth LE
 *      |
 *      v
 *   ViO T33 6 Li hearing aids
 *
 *
 * Input selection:
 * ----------------
 *
 * USB audio has priority.
 *
 * If USB PCM packets are detected:
 *
 *   TV USB -> Pico-ASHA -> hearing aids
 *
 * If USB PCM disappears for USB_AUDIO_HOLD_US:
 *
 *   TV 3.5 mm -> WM8782S -> I2S bridge -> Pico-ASHA -> hearing aids
 *
 * I2S DMA continues running while USB is selected, but completed DMA
 * buffers are discarded so old analog audio is not replayed when falling
 * back to I2S.
 *
 *
 * I2S silence handling:
 * ---------------------
 *
 * The analog path contains silence detection with hysteresis:
 *
 *   I2S_SILENCE_TIMEOUT_MS
 *       Continuous silence before stopping the ASHA PCM stream.
 *
 *   I2S_START_TIMEOUT_MS
 *       Continuous detected audio required before restarting the stream.
 *       This prevents ADC noise from repeatedly triggering ACP/ASP starts.
 *
 *   I2S_SILENCE_THRESHOLD
 *       Absolute PCM threshold below which a block is considered silent.
 *
 *
 * Important:
 * ----------
 *
 * Do NOT remove the volume update in I2S mode:
 *
 *   asha_audio_set_curr_usb_vol(...)
 *
 * Pico-ASHA normally updates its ASHA volume state from audio_task().
 * Since audio_task() is not used for PCM while I2S is selected, the
 * volume update must still be performed separately. Without it, I2S
 * audio was tested to be extremely quiet.
 *
 *
 * Known working:
 * --------------
 *
 *   - Pico 2 W
 *   - WM8782S at 96 kHz
 *   - ViO T33 6 Li hearing aids
 *   - USB audio -> ASHA
 *   - Analog 3.5 mm -> WM8782S -> I2S -> ASHA
 *   - Automatic USB priority / I2S fallback
 *   - Standalone operation from a USB power supply
 *   - Automatic ASHA stop/start on analog silence
 *
 */




#include "pico/stdlib.h"

#include "asha_audio.h"
#include "audio_config.h"
#include "dma_audio.h"
#include "i2s_asha_bridge.h"


// -----------------------------------------------------------------------------
// Configuration
// -----------------------------------------------------------------------------

#define ASHA_BRIDGE_OUTPUT_FRAMES 48
#define ASHA_BRIDGE_FIR_TAPS      15

// DMA buffer contains alternating 32-bit words:
//
//   LEFT, RIGHT, LEFT, RIGHT, ...
//
// AUDIO_BUFFER_SIZE = 256 words
// therefore:
//   256 / 2 = 128 stereo frames
//
#define ASHA_BRIDGE_DMA_FRAMES (AUDIO_BUFFER_SIZE / 2)





// -----------------------------------------------------------------------------
// 96 kHz -> 48 kHz low-pass FIR
// -----------------------------------------------------------------------------
//
// Q15 coefficients.
// Filtering is performed before dropping every second sample.
//

static const int16_t fir_coeffs[ASHA_BRIDGE_FIR_TAPS] =
{
    -111,
       0,
     620,
       0,
   -2134,
       0,
    9817,
   16384,
    9817,
       0,
   -2134,
       0,
     620,
       0,
    -111
};


// -----------------------------------------------------------------------------
// FIR state
// -----------------------------------------------------------------------------

static unsigned int silence_ms = 0;
static unsigned int audio_ms = 0;
static bool stream_enabled = false;


static int16_t history_left[ASHA_BRIDGE_FIR_TAPS];
static int16_t history_right[ASHA_BRIDGE_FIR_TAPS];

static unsigned int history_pos = 0;


// -----------------------------------------------------------------------------
// Decimator state
// -----------------------------------------------------------------------------

static bool decimation_phase = false;


// -----------------------------------------------------------------------------
// Pico-ASHA output buffer
// -----------------------------------------------------------------------------

static PCMStereoSample asha_buffer[ASHA_BRIDGE_OUTPUT_FRAMES];

static unsigned int asha_buffer_pos = 0;


// -----------------------------------------------------------------------------
// Convert one raw 32-bit I2S slot to signed 16-bit PCM
// -----------------------------------------------------------------------------

static int16_t i2s_to_pcm16(uint32_t raw)
{
    int32_t signed_sample = (int32_t)raw;

    return (int16_t)(signed_sample >> 16);
}


// -----------------------------------------------------------------------------
// FIR filter one channel
// -----------------------------------------------------------------------------

static int16_t fir_filter(
    const int16_t *history,
    unsigned int newest)
{
    int64_t accumulator = 0;

    unsigned int index = newest;

    for (unsigned int tap = 0;
         tap < ASHA_BRIDGE_FIR_TAPS;
         ++tap)
    {
        accumulator +=
            (int32_t)history[index] *
            (int32_t)fir_coeffs[tap];

        if (index == 0)
        {
            index = ASHA_BRIDGE_FIR_TAPS - 1;
        }
        else
        {
            --index;
        }
    }

    // Convert Q15 result back to PCM.
    accumulator >>= 15;

    // Saturate to int16 range.
    if (accumulator > 32767)
    {
        accumulator = 32767;
    }
    else if (accumulator < -32768)
    {
        accumulator = -32768;
    }

    return (int16_t)accumulator;
}



//check for silent block
static bool block_is_silent(void)
{
    for (unsigned int i =0;
        i < ASHA_BRIDGE_OUTPUT_FRAMES;
        i++)

    {
        int32_t left = asha_buffer[i].left;
        int32_t right = asha_buffer[i].right;

        if (left < 0)
        {
            left = -left;
        }

        if (right < 0)
        {
            right = -right;
        }

        if (left > I2S_SILENCE_THRESHOLD || right > I2S_SILENCE_THRESHOLD)
        {
            return false;
        }

    }

    return true;

}






// -----------------------------------------------------------------------------
// Process one 96 kHz stereo frame
// -----------------------------------------------------------------------------

static void consume_frame(
    int16_t left,
    int16_t right)
{
    history_left[history_pos] = left;
    history_right[history_pos] = right;

    unsigned int newest = history_pos;

    ++history_pos;

    if (history_pos >= ASHA_BRIDGE_FIR_TAPS)
    {
        history_pos = 0;
    }


    // 96 kHz -> 48 kHz
    //
    // Only one out of every two input frames becomes
    // an output frame.

    decimation_phase = !decimation_phase;

    if (!decimation_phase)
    {
        return;
    }


    int16_t filtered_left =
        fir_filter(history_left, newest);

    int16_t filtered_right =
        fir_filter(history_right, newest);


    asha_buffer[asha_buffer_pos].left =
        filtered_left;

    asha_buffer[asha_buffer_pos].right =
        filtered_right;

    ++asha_buffer_pos;


        // 48 samples at 48 kHz = 1 ms.
        //only start if input for a while and stop if no input for a while
    if (asha_buffer_pos >= ASHA_BRIDGE_OUTPUT_FRAMES)
    {
        bool silent = block_is_silent();

        if (stream_enabled)
        {
            if (silent)
            {
                if (silence_ms < I2S_SILENCE_TIMEOUT_MS)
                {
                    ++silence_ms;
                }

                if (silence_ms >= I2S_SILENCE_TIMEOUT_MS)
                {
                    stream_enabled = false;
                    audio_ms = 0;

                    asha_audio_set_pcm_streaming_enabled(false);
                }
            }
            else
            {
                silence_ms = 0;
            }
        }
        else
        {
            /*
            * Stream is currently stopped.
            *
            * Require sustained audio before restarting so that
            * individual ADC noise spikes cannot restart ASHA.
            */
            if (!silent)
            {
                if (audio_ms < I2S_START_TIMEOUT_MS)
                {
                    ++audio_ms;
                }

                if (audio_ms >= I2S_START_TIMEOUT_MS)
                {
                    stream_enabled = true;
                    silence_ms = 0;

                    asha_audio_set_pcm_streaming_enabled(true);
                }
            }
            else
            {
                audio_ms = 0;
            }
        }


        if (stream_enabled)
        {
            asha_audio_encode_1ms_pcm(
                asha_buffer,
                ASHA_BRIDGE_OUTPUT_FRAMES
            );
        }

        asha_buffer_pos = 0;
    }
}


// -----------------------------------------------------------------------------
// Process one completed DMA buffer
// -----------------------------------------------------------------------------

static void consume_dma_buffer(const uint32_t *buffer)
{
    if (buffer == NULL)
    {
        return;
    }

    for (unsigned int frame = 0;
         frame < ASHA_BRIDGE_DMA_FRAMES;
         ++frame)
    {
        uint32_t raw_left =
            buffer[(frame * 2) + 0];

        uint32_t raw_right =
            buffer[(frame * 2) + 1];


        int16_t left =
            i2s_to_pcm16(raw_left);

        int16_t right =
            i2s_to_pcm16(raw_right);


        consume_frame(left, right);
    }
}


// -----------------------------------------------------------------------------
// Public initialization
// -----------------------------------------------------------------------------

void i2s_asha_bridge_init(void)
{
    silence_ms = 0;
    audio_ms = 0;
    stream_enabled = false;
    asha_audio_set_pcm_streaming_enabled(false);
    history_pos = 0;
    asha_buffer_pos = 0;
    decimation_phase = false;


    for (unsigned int i = 0;
         i < ASHA_BRIDGE_FIR_TAPS;
         ++i)
    {
        history_left[i] = 0;
        history_right[i] = 0;
    }


    for (unsigned int i = 0;
         i < ASHA_BRIDGE_OUTPUT_FRAMES;
         ++i)
    {
        asha_buffer[i].left = 0;
        asha_buffer[i].right = 0;
    }
}


// -----------------------------------------------------------------------------
// Foreground processing task
// -----------------------------------------------------------------------------

void i2s_asha_bridge_task(void)
{
    uint32_t *ready_buffer = NULL;


    while (dma_audio_get_ready_buffer(&ready_buffer))
    {
        if (ready_buffer != NULL)
        {
            consume_dma_buffer(ready_buffer);
        }

        ready_buffer = NULL;
    }
}