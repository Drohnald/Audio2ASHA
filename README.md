
# Audio2ASHA
Audio2ASHA is mainly a combination of Pico ASHA (https://shermp.github.io/Pico-ASHA) and pico-i2s-usb https://github.com/anauseam/pico-i2s-usb .

It uses a Raspberry Pi Pico 2w and a WM8782 Analog - Digital converter to enable both streaming from USB Sound as well as from Audio Jack or Cinch to ASHA capable hearing aids.

All credits go to the developers shermp and anauseam for their fantastic interfaces. 

Remember to check all licenses, also from the code that these 2 projects have been using.


Unless otherwise noted in the file, the source code in this repository is licenced under the BSD 3-clause licence, however any binaries must be provided on a more restrictive licence, see below.

Pico-ASHA uses [BTstack by BlueKitchen](https://github.com/bluekitchen/btstack), which in general has a non-commercial free licence available. Raspberry Pi have provided a [commercial licence](https://github.com/raspberrypi/pico-sdk/blob/master/src/rp2_common/pico_btstack/LICENSE.RP) if using BTstack on official Raspberry Pi Pico W or WH. If Pico-ASHA is implemented on any other device, then the terms of the original BlueKitchen BTstack licence MUST be adhered to.

