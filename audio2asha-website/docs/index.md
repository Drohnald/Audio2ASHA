# Audio2ASHA

**Audio2ASHA** combines [Pico-ASHA](https://shermp.github.io/Pico-ASHA) and
[pico-i2s-usb](https://github.com/anauseam/pico-i2s-usb).

It uses a **Raspberry Pi Pico 2 W** and a **WM8782 analog-to-digital converter**
to enable audio streaming to ASHA-capable hearing aids from both USB audio and
analog audio sources, such as a 3.5 mm audio jack or Cinch (RCA) input.

## How it fits together

- **USB audio:** stream sound from a USB audio source.
- **Analog audio:** connect an audio source through an audio jack or Cinch input.
- **Wireless output:** send audio to ASHA-capable hearing aids.

The project brings these pieces together in one device. See the
[Making of](making-of.md) page for build photos and notes.

## Credits

All credits for the underlying interfaces go to **shermp** and **anauseam**.
Thank you for their fantastic work:

- [Pico-ASHA by shermp](https://shermp.github.io/Pico-ASHA)
- [pico-i2s-usb by anauseam](https://github.com/anauseam/pico-i2s-usb)

## Licensing

Unless otherwise noted in a file, the source code in this repository is
licensed under the **BSD 3-Clause License**. Binaries, however, must be
provided under a more restrictive license as described below.

Please check the licenses of all upstream projects and of the code used by
those projects before redistributing or building on this work.

### BTstack and Pico-ASHA

Pico-ASHA uses [BTstack by BlueKitchen](https://github.com/bluekitchen/btstack).
In general, BTstack offers a free license for non-commercial use. Raspberry Pi
has also provided a
[commercial license for BTstack](https://github.com/raspberrypi/pico-sdk/blob/master/src/rp2_common/pico_btstack/LICENSE.RP)
when using BTstack on official Raspberry Pi Pico W or WH devices.

If Pico-ASHA is implemented on any other device, the terms of the original
BlueKitchen BTstack license **must** be followed.

> This page is a project summary, not legal advice. Review the current license
> texts and the exact terms that apply to your use before redistributing source
> code or binaries.
