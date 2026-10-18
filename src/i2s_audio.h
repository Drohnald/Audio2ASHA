#ifndef I2S_AUDIO_H
#define I2S_AUDIO_H

#include "hardware/pio.h"
#include "pico/stdlib.h" // IWYU pragma: keep

//check for c++ code, if yes mark it
#ifdef __cplusplus
extern "C" {
#endif

// Initializes the physical pins, clocks, and PIO state machines.
// Populates pio_out and sm_out with the selected PIO instance and State Machine.
void i2s_audio_init(PIO *pio_out, uint *sm_out);

// Starts the I2S hardware
void i2s_audio_start(PIO pio, uint sm);

//closes the if on c++ code check
#ifdef __cplusplus
}
#endif

#endif // I2S_AUDIO_H