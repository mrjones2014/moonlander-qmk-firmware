#define USB_SUSPEND_WAKEUP_DELAY 0
#define NO_AUTO_SHIFT_TAB
#define NO_AUTO_SHIFT_ALPHA
#define SERIAL_NUMBER "9QzP7/pjDd9D"
#define LAYER_STATE_8BIT
#define RGB_MATRIX_STARTUP_SPD 60
#define LEADER_NO_TIMEOUT
#define LEADER_PER_KEY_TIMING
#define LEADER_TIMEOUT 250
// Zelda puzzle solved song
// Composed using https://getreuer.info/posts/keyboards/qmk-song-player
#define ZELDA_PUZZLE                                                           \
  Q__NOTE(_G5), Q__NOTE(_FS5), Q__NOTE(_DS5), Q__NOTE(_A4), Q__NOTE(_GS4),     \
      Q__NOTE(_E5), Q__NOTE(_GS5), HD_NOTE(_C6),
#define STARTUP_SONG SONG(ZELDA_PUZZLE)
