#include "action_util.h"
#include "color.h"
#include "keycodes.h"
#include "quantum.h"
#include "rgb_matrix.h"
#include "unicode.h"
#include QMK_KEYBOARD_H
#include "os_detection.h"
#include "version.h"
#define MOON_LED_LEVEL LED_LEVEL
#ifndef ZSA_SAFE_RANGE
#define ZSA_SAFE_RANGE SAFE_RANGE
#endif

enum custom_keycodes {
  RGB_SLD = ZSA_SAFE_RANGE,
  FAT_ARROW,
  THIN_ARROW,
  DEL_WORD,
};

enum tap_dance_codes {
  DANCE_0,
  DANCE_1,
};

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    // base
    [0] = LAYOUT_moonlander(
        KC_ESCAPE, KC_1, KC_2, KC_3, KC_4, KC_5, TD(DANCE_0),                                                            KC_AUDIO_VOL_UP, KC_6, KC_7, KC_8, KC_9, KC_0, KC_MINUS,
        KC_TAB, KC_Q, KC_W, KC_E, KC_R, KC_T, TD(DANCE_1),                                                                      KC_AUDIO_VOL_DOWN, KC_Y, KC_U, KC_I, KC_O, KC_P, KC_BSLS,
        KC_LEFT_SHIFT, KC_A, KC_S, KC_D, KC_F, KC_G, KC_HYPR,                                                                   KC_MEH, KC_H, KC_J, KC_K, KC_L, KC_SCLN, KC_QUOTE,
        KC_GRAVE, MT(MOD_LCTL, KC_Z), KC_X, KC_C, KC_V, KC_B,                                                                   KC_N, KC_M, KC_COMMA, KC_DOT, KC_SLASH, KC_EQUAL,
        KC_LEFT_CTRL, QK_LEADER, KC_LEFT_ALT, KC_LEFT, KC_RIGHT,    KC_LEFT_ALT,                      LGUI(KC_SPACE),           KC_DOWN, KC_UP, KC_LBRC, KC_RBRC, TO(2),
                                                         KC_SPACE, KC_BSPC, KC_LEFT_GUI,      LCTL(LSFT(KC_SPACE)), KC_LEFT_SHIFT, LT(1, KC_ENTER) // thumbs
    ),
    // symbols and stuff
    [1] = LAYOUT_moonlander(
        KC_TRANSPARENT, KC_EXLM, KC_AT, KC_HASH, KC_DLR, KC_PERC, KC_TRANSPARENT,                                                             KC_TRANSPARENT, KC_CIRC, KC_AMPR, KC_ASTR, KC_LPRN, KC_RPRN, KC_F11,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_LCBR, KC_RCBR, FAT_ARROW,                                          THIN_ARROW, KC_LPRN, KC_RPRN, KC_LABK, KC_RABK, KC_TRANSPARENT, KC_F12,
        KC_PAGE_UP, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_F3, KC_F4,                                             KC_UNDS, KC_LBRC, KC_RBRC, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, DEL_WORD,
        KC_PGDN, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_LABK,                                     KC_RABK, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, LALT(KC_LEFT), LALT(KC_RIGHT),                                                  KC_TRANSPARENT,     KC_TRANSPARENT,   KC_TRANSPARENT, KC_DOT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
                                                                          KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,   KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT // thumbs
    ),
    // gaming
    [2] = LAYOUT_moonlander(
        KC_ESCAPE, KC_1, KC_2, KC_3, KC_4, KC_5, KC_6,                                                                     KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_F12,
        KC_TAB, KC_Q, KC_W, KC_E, KC_R, KC_TRANSPARENT, KC_Y,                                                              KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_LEFT_SHIFT, KC_A, KC_S, KC_D, KC_F, KC_G, KC_H,                                                                 KC_F6, KC_F7, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_LEFT_CTRL, KC_Z, KC_X, KC_C, KC_V, KC_B,                                                                        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, TO(3),
        KC_X, KC_TRANSPARENT, KC_TRANSPARENT, KC_C, KC_SPACE,           KC_F3,                         LALT(KC_TAB),       KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, TO(0),
                                                               KC_X, KC_F1, KC_F2,      KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT // thumbs
    ),
    // function keys and numpad
    [3] = LAYOUT_moonlander(
        KC_HOME, KC_F1, KC_F2, KC_F3, KC_F4, KC_F5, KC_TRANSPARENT,                                                                                                                  KC_TRANSPARENT, KC_F6, KC_F7, KC_F8, KC_F9, KC_F10, KC_F11,
        KC_TRANSPARENT, KC_KP_1, KC_KP_2, KC_KP_3, KC_KP_4, KC_KP_5, KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_KP_6, KC_KP_7, KC_KP_8, KC_KP_9, KC_KP_0, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                              KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                              KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
        KC_TRANSPARENT, QK_BOOTLOADER, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                    KC_TRANSPARENT,                        KC_TRANSPARENT,    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, TO(0),
                                                                                                         KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,   KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT // thumbs
    ),
};
// clang-format on

void keyboard_post_init_user(void) { rgb_matrix_enable(); }

void handle_send_unicode(const char *str) {
  os_variant_t detected_os = detected_host_os();
  if (detected_os == OS_MACOS) {
    set_unicode_input_mode(UNICODE_MODE_MACOS);
  } else if (detected_os == OS_LINUX) {
    set_unicode_input_mode(UNICODE_MODE_LINUX);
  } else {
    return;
  }
  unicode_input_start();
  send_unicode_string(str);
  unicode_input_finish();
}

void leader_end_user(void) {
  if (leader_sequence_two_keys(KC_S, KC_H)) {
    handle_send_unicode("¯\\_(ツ)_/¯");
  } else if (leader_sequence_two_keys(KC_T, KC_F)) {
    handle_send_unicode("(╯°□°)╯︵ ┻━┻");
  } else if (leader_sequence_two_keys(KC_MINUS, KC_MINUS)) {
    tap_code16(QK_BOOTLOADER);
  }
}

hsv_t layer_colors[] = {
    {0, 255, 120},   // Layer 0: red
    {96, 255, 120},  // Layer 1: green
    {160, 255, 120}, // Layer 2: blue
    {32, 255, 120},  // Layer 3: yellow
};

bool rgb_matrix_indicators_user(void) {
  if (rawhid_state.rgb_control) {
    return false;
  }

  uint8_t layer = get_highest_layer(layer_state);
  hsv_t color = layer_colors[layer];
  rgb_t rgb = hsv_to_rgb(color);

  for (uint8_t row = 0; row < MATRIX_ROWS; row++) {
    for (uint8_t col = 0; col < MATRIX_COLS; col++) {
      int8_t led_index = g_led_config.matrix_co[row][col];
      if (led_index < 0) {
        continue;
      }

      keypos_t keypos = {.row = row, .col = col};
      uint16_t kc = keymap_key_to_keycode(layer, keypos);

      if (layer == 0 || kc != KC_TRANSPARENT) {
        rgb_matrix_set_color(led_index, rgb.r, rgb.g, rgb.b);
      } else {
        rgb_matrix_set_color(led_index, 0, 0, 0);
      }
    }
  }

  return true;
}

typedef struct {
  bool is_press_action;
  uint8_t step;
} tap;

enum {
  SINGLE_TAP = 1,
  SINGLE_HOLD,
  DOUBLE_TAP,
  DOUBLE_HOLD,
  DOUBLE_SINGLE_TAP,
  MORE_TAPS
};

static tap dance_state[6];

uint8_t dance_step(tap_dance_state_t *state) {
  if (state->count == 1) {
    if (state->interrupted || !state->pressed)
      return SINGLE_TAP;
    else
      return SINGLE_HOLD;
  } else if (state->count == 2) {
    if (state->interrupted)
      return DOUBLE_SINGLE_TAP;
    else if (state->pressed)
      return DOUBLE_HOLD;
    else
      return DOUBLE_TAP;
  }
  return MORE_TAPS;
}

void on_dance_0(tap_dance_state_t *state, void *user_data) {
  if (state->count == 3) {
    tap_code16(KC_PSCR);
    tap_code16(KC_PSCR);
    tap_code16(KC_PSCR);
  }
  if (state->count > 3) {
    tap_code16(KC_PSCR);
  }
}

void dance_0_finished(tap_dance_state_t *state, void *user_data) {
  dance_state[0].step = dance_step(state);
  switch (dance_state[0].step) {
  case SINGLE_TAP:
    register_code16(KC_PSCR);
    break;
  case SINGLE_HOLD:
    register_code16(LGUI(LSFT(KC_4)));
    break;
  case DOUBLE_TAP:
    register_code16(LGUI(LSFT(KC_3)));
    break;
  case DOUBLE_SINGLE_TAP:
    tap_code16(KC_PSCR);
    register_code16(KC_PSCR);
  }
}

void dance_0_reset(tap_dance_state_t *state, void *user_data) {
  wait_ms(10);
  switch (dance_state[0].step) {
  case SINGLE_TAP:
    unregister_code16(KC_PSCR);
    break;
  case SINGLE_HOLD:
    unregister_code16(LGUI(LSFT(KC_4)));
    break;
  case DOUBLE_TAP:
    unregister_code16(LGUI(LSFT(KC_3)));
    break;
  case DOUBLE_SINGLE_TAP:
    unregister_code16(KC_PSCR);
    break;
  }
  dance_state[0].step = 0;
}

void on_dance_1(tap_dance_state_t *state, void *user_data) {
  if (state->count == 3) {
    tap_code16(KC_MEDIA_PLAY_PAUSE);
    tap_code16(KC_MEDIA_PLAY_PAUSE);
    tap_code16(KC_MEDIA_PLAY_PAUSE);
  }
  if (state->count > 3) {
    tap_code16(KC_MEDIA_PLAY_PAUSE);
  }
}

void dance_1_finished(tap_dance_state_t *state, void *user_data) {
  dance_state[1].step = dance_step(state);
  switch (dance_state[1].step) {
  case SINGLE_TAP:
    register_code16(KC_MEDIA_PLAY_PAUSE);
    break;
  case DOUBLE_TAP:
    register_code16(KC_MEDIA_NEXT_TRACK);
    break;
  case DOUBLE_SINGLE_TAP:
    tap_code16(KC_MEDIA_PLAY_PAUSE);
    register_code16(KC_MEDIA_PLAY_PAUSE);
  }
}

void dance_1_reset(tap_dance_state_t *state, void *user_data) {
  wait_ms(10);
  switch (dance_state[1].step) {
  case SINGLE_TAP:
    unregister_code16(KC_MEDIA_PLAY_PAUSE);
    break;
  case DOUBLE_TAP:
    unregister_code16(KC_MEDIA_NEXT_TRACK);
    break;
  case DOUBLE_SINGLE_TAP:
    unregister_code16(KC_MEDIA_PLAY_PAUSE);
    break;
  }
  dance_state[1].step = 0;
}

tap_dance_action_t tap_dance_actions[] = {
    [DANCE_0] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_0, dance_0_finished,
                                             dance_0_reset),
    [DANCE_1] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_1, dance_1_finished,
                                             dance_1_reset),
};

// Declaratively define cross-OS GUI/Ctrl shortcuts

typedef struct {
  uint16_t keycode;
  uint8_t other_allowed_mods;
} gui_shortcut_t;

#define GUI_ENTRY(key, allowed) {key, allowed}

static const gui_shortcut_t gui_shortcuts[] = {
    GUI_ENTRY(KC_C, 0),
    GUI_ENTRY(KC_V, 0),
    GUI_ENTRY(KC_X, 0),
    GUI_ENTRY(KC_Z, MOD_MASK_SHIFT),
    GUI_ENTRY(KC_A, 0),
    GUI_ENTRY(KC_S, 0),
    GUI_ENTRY(KC_T, MOD_MASK_SHIFT),
    GUI_ENTRY(KC_N, MOD_MASK_SHIFT),
    GUI_ENTRY(KC_O, 0),
    GUI_ENTRY(KC_F, 0),
    GUI_ENTRY(KC_W, 0),
    GUI_ENTRY(KC_Q, 0),
    GUI_ENTRY(KC_R, 0),
    GUI_ENTRY(KC_LEFT, 0),
    GUI_ENTRY(KC_RIGHT, 0),
    GUI_ENTRY(KC_DOT, 0),
    GUI_ENTRY(KC_L, 0),
};

#define GUI_SHORTCUT_COUNT (sizeof(gui_shortcuts) / sizeof(gui_shortcuts[0]))

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  os_variant_t detected_os = detected_host_os();
  bool is_apple = (detected_os == OS_MACOS || detected_os == OS_IOS);

  // Custom logic to unify keyboard shortcust across macOS and Linux on my
  // Moonlander MK I
  if (record->event.pressed) {
    // "Delete Word" keycode handling
    if (keycode == DEL_WORD) {
      uint8_t mod = is_apple ? KC_LALT : KC_LCTL;
      register_code(mod);
      tap_code(KC_BSPC);
      unregister_code(mod);
      return true;
    }

    uint16_t base_keycode = keycode;
    if (IS_QK_MOD_TAP(keycode)) {
      base_keycode = QK_MOD_TAP_GET_TAP_KEYCODE(keycode);
    }

    // Common Cmd/Ctrl key shortcuts handling
    uint8_t mods = get_mods();
    // In QMK, the "GUI" key is the "Command" key on macOS and the "Super" key
    // on Linux Only intercept when GUI modifier is held
    if (mods & MOD_MASK_GUI) {
      for (uint8_t i = 0; i < GUI_SHORTCUT_COUNT; i++) {
        const gui_shortcut_t *entry = &gui_shortcuts[i];
        if (entry->keycode != base_keycode) {
          continue;
        }

        // Compute non-GUI modifiers currently held.
        uint8_t extra = mods & ~MOD_MASK_GUI;

        // If any non-GUI modifiers are held that are not allowed for this
        // shortcut, bail out and let normal processing happen.
        if (extra & ~entry->other_allowed_mods) {
          break;
        }

        uint8_t saved_mods = mods;
        clear_mods();

        // Apply correct modifier for the OS, to be combined with any of the
        // other allowed modifiers.
        add_mods(extra | (is_apple ? MOD_MASK_GUI : MOD_MASK_CTRL));
        tap_code(base_keycode);

        // Restore original modifier state (including the physically held GUI).
        clear_mods();
        set_mods(saved_mods);
        // we handled it, stop processing
        return false;
      }
    }

    switch (base_keycode) {
    case FAT_ARROW:
      SEND_STRING("=>");
      return false;
    case THIN_ARROW:
      SEND_STRING("->");
      return false;
    default:
      break;
    }
  }

  return true;
}
