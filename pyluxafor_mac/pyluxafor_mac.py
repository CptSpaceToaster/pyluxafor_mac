#!/usr/bin/env python3

import hid
import time


class LuxaforFlag(object):
    DEVICE_VENDOR_ID = 0x04d8
    DEVICE_PRODUCT_ID = 0xf372

    MODE_STATIC_COLOUR = 1
    MODE_FADE_COLOUR = 2
    MODE_STROBE = 3
    MODE_WAVE = 4
    MODE_PATTERN = 6

    LED_TAB_1 = 1
    LED_TAB_2 = 2
    LED_TAB_3 = 3
    LED_BACK_1 = 4
    LED_BACK_2 = 5
    LED_BACK_3 = 6
    LED_TAB_SIDE = 65
    LED_BACK_SIDE = 66
    LED_ALL = 255

    WAVE_SINGLE_SMALL = 1
    WAVE_SINGLE_LARGE = 2
    WAVE_DOUBLE_SMALL = 3
    WAVE_DOUBLE_LARGE = 4

    PATTERN_LUXAFOR = 1
    PATTERN_RANDOM1 = 2
    PATTERN_RANDOM2 = 3
    PATTERN_RANDOM3 = 4
    PATTERN_POLICE = 5
    PATTERN_RANDOM4 = 6
    PATTERN_RANDOM5 = 7
    PATTERN_RAINBOWWAVE = 8

    def __init__(self):
        self.dev = hid.device()
        self.dev.open(
            LuxaforFlag.DEVICE_VENDOR_ID, 
            LuxaforFlag.DEVICE_PRODUCT_ID
        )

    def __del__(self):
        self.dev.close()

    def set_static_color(self, r, g, b, led=255):
        self.dev.write([LuxaforFlag.MODE_STATIC_COLOUR, led, r, g, b])

    def set_fade_color(self, r, g, b, led=255, duration=20):
        self.dev.write([LuxaforFlag.MODE_FADE_COLOUR, led, r, g, b, duration])

    def set_strobe(self, r, g, b, led=255, duration=20, repeat=2):
        self.dev.write([LuxaforFlag.MODE_STROBE, led, r, g, b, duration, 0, repeat])

    def set_wave(self, r, g, b, wave_type=4, duration=20, repeat=1):
        self.dev.write([LuxaforFlag.MODE_WAVE, wave_type, r, g, b, duration, 0, repeat])

    def set_pattern(self, pattern_id, repeat=1):
        self.dev.write([LuxaforFlag.MODE_PATTERN, pattern_id, repeat])

    def fade_off(self):
        self.set_fade_color(0, 0, 0)


def main():
    flag = LuxaforFlag()
    flag.fade_off()
    time.sleep(1)
    flag.set_fade_color(200, 0, 0)
    time.sleep(1)
    flag.set_fade_color(200, 150, 0)
    time.sleep(1)
    flag.set_fade_color(0, 200, 0)
    time.sleep(1)
    flag.fade_off()
    time.sleep(1)
    flag.set_pattern(LuxaforFlag.PATTERN_RANDOM1, repeat=3)


if __name__ == '__main__':
    main()
