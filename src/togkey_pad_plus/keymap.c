#include QMK_KEYBOARD_H

bool encoder_update_user(uint8_t index, bool clockwise) {
  tap_code(clockwise ? KC_VOLU : KC_VOLD);
  return false; // we handled it
}

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [0] = LAYOUT(
        TO(1),
        KC_VOLD, KC_MUTE, KC_VOLU,
        KC_MPRV, KC_MPLY, KC_MNXT
    ),
    [1] = LAYOUT(
        TO(2),
        KC_1,   KC_2, KC_3,
        KC_4,   KC_5,   KC_6
    ),
    [2] = LAYOUT(
        TO(3),
        KC_A,   KC_B, KC_C,
        KC_D,   KC_E,   KC_F
    ),
    [3] = LAYOUT(
        TO(0),
        KC_J,   KC_K, KC_L,
        KC_M,   KC_N, KC_O
    )
};
// clang-format on
