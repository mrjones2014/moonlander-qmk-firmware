#pragma once

// Hold top left key while plugging in to enter bootloader mode
#define BOOTMAGIC_ROW 1
#define BOOTMAGIC_COLUMN 0

// OLED
#define OLED_TIMEOUT 0
#define OLED_DISPLAY_128X64
#define I2C_DRIVER I2CD1
#define I2C1_SDA_PIN GP2
#define I2C1_SCL_PIN GP3

#define ENCODER_MAP_KEY_DELAY 10
#ifdef ENCODER_RESOLUTION
#undef ENCODER_RESOLUTION
#endif
#define ENCODER_RESOLUTION 4
#define ENCODER_DIRECTION_FLIP
