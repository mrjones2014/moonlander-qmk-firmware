# Derivation to generate a ready-to-use .clangd configuration and Moonlander
# layout stub header for clangd LSP analysis. Produces:
#   $out/.clangd
#   $out/stubs/layout_stubs.h
#
# Rationale: Instead of a runtime script that mutates the working tree, this
# derivation creates immutable artifacts that editors can symlink/copy.
{ pkgs, qmk-firmware, ... }:

let
  inherit (pkgs) stdenv;
  # We only need qmk-firmware as a reference to scan include dirs.
  src = qmk-firmware;
in
stdenv.mkDerivation {
  pname = "qmk-clangd-config";
  version = "1.0";

  inherit src;
  dontUnpack = true;

  buildInputs = [
    pkgs.findutils
    pkgs.gawk
    pkgs.coreutils
    pkgs.clang
  ];

  buildPhase = ''
    echo "Scanning QMK include directories..."
    # Collect include directories while excluding irrelevant / heavy families.
    QMK_INCLUDES=$(${pkgs.findutils}/bin/find "${src}" \
      -type d \
      -not -path "*/.*" \
      -not -path "*/tests/*" \
      -not -path "*/docs/*" \
      -not -path "*/.build/*" \
      -not -path "*/modules/*" \
      -not -path "*/lib/chibios/os/common/ext/ST/STM32F0*" \
      -not -path "*/lib/chibios/os/common/ext/ST/STM32F1*" \
      -not -path "*/lib/chibios/os/common/ext/ST/STM32F2*" \
      -not -path "*/lib/chibios/os/common/ext/ST/STM32F4*" \
      -not -path "*/lib/chibios/os/common/ext/ST/STM32F7*" \
      -not -path "*/lib/chibios/os/common/ext/ST/STM32L0*" \
      -not -path "*/lib/chibios/os/common/ext/ST/STM32L1*" \
      -not -path "*/lib/chibios/os/common/ext/ST/STM32L4*" \
      -not -path "*/lib/chibios/os/common/ext/ST/STM32G0*" \
      -not -path "*/lib/chibios/os/common/ext/ST/STM32H7*" \
      -not -path "*/lib/chibios/os/common/startup/ARMCMx/devices/STM32F0*" \
      -not -path "*/lib/chibios/os/common/startup/ARMCMx/devices/STM32F1*" \
      -not -path "*/lib/chibios/os/common/startup/ARMCMx/devices/STM32F2*" \
      -not -path "*/lib/chibios/os/common/startup/ARMCMx/devices/STM32F4*" \
      -not -path "*/lib/chibios/os/common/startup/ARMCMx/devices/STM32L0*" \
      -not -path "*/lib/chibios/os/common/startup/ARMCMx/devices/STM32L1*" \
      -not -path "*/lib/chibios/os/hal/ports/STM32/STM32F0*" \
      -not -path "*/lib/chibios/os/hal/ports/STM32/STM32F1*" \
      -not -path "*/lib/chibios/os/hal/ports/STM32/STM32F2*" \
      -not -path "*/lib/chibios/os/hal/ports/STM32/STM32F4*" \
      -not -path "*/lib/chibios/os/hal/ports/STM32/STM32F7*" \
      -not -path "*/lib/chibios/os/hal/ports/STM32/STM32L0*" \
      -not -path "*/lib/chibios/os/hal/ports/STM32/STM32L1*" \
      -not -path "*/lib/chibios/os/hal/ports/STM32/STM32L4*" \
      -not -path "*/lib/chibios/os/hal/ports/STM32/STM32G0*" \
      -not -path "*/lib/chibios/os/hal/ports/STM32/STM32H7*" \
      -not -path "*/platforms/chibios/boards/*STM32F0*" \
      -not -path "*/platforms/chibios/boards/*STM32F1*" \
      -not -path "*/platforms/chibios/boards/*STM32F2*" \
      -not -path "*/platforms/chibios/boards/*STM32F4*" \
      -not -path "*/platforms/chibios/boards/*STM32L0*" \
      -not -path "*/platforms/chibios/boards/*STM32L1*" \
      -not -path "*/platforms/chibios/boards/*_F0*" \
      -not -path "*/platforms/chibios/boards/*_F1*" \
      -not -path "*/platforms/chibios/boards/*_F2*" \
      -not -path "*/platforms/chibios/boards/*_F4*" \
      -not -path "*/platforms/chibios/boards/*_L0*" \
      -not -path "*/platforms/chibios/boards/*_L1*" \
      -not -path "*/lib/chibios-contrib/os/hal/ports/STM32/STM32F0*" \
      -not -path "*/lib/chibios-contrib/os/hal/ports/STM32/STM32L0*" \
      | sed 's|^|    - -I|')

    echo "Found $(echo "$QMK_INCLUDES" | wc -l) include directories."

    mkdir -p $out/stubs

    cat > $out/stubs/layout_stubs.h <<'LAYOUT_STUB'
    #pragma once
    #include <stdint.h>

    #define LAYOUT_moonlander( \
        k00, k01, k02, k03, k04, k05, k06,           k60, k61, k62, k63, k64, k65, k66, \
        k10, k11, k12, k13, k14, k15, k16,           k70, k71, k72, k73, k74, k75, k76, \
        k20, k21, k22, k23, k24, k25, k26,           k80, k81, k82, k83, k84, k85, k86, \
        k30, k31, k32, k33, k34, k35,                     k91, k92, k93, k94, k95, k96, \
        k40, k41, k42, k43, k44,      k53,           kb3,      ka2, ka3, ka4, ka5, ka6, \
                            k50, k51, k52,           kb4, kb5, kb6 \
    ) \
    { \
        { k00, k01, k02, k03, k04, k05, k06 }, \
        { k10, k11, k12, k13, k14, k15, k16 }, \
        { k20, k21, k22, k23, k24, k25, k26 }, \
        { k30, k31, k32, k33, k34, k35, 0 }, \
        { k40, k41, k42, k43, k44, 0, 0 }, \
        { k50, k51, k52, k53, 0, 0, 0 }, \
        { k60, k61, k62, k63, k64, k65, k66 }, \
        { k70, k71, k72, k73, k74, k75, k76 }, \
        { k80, k81, k82, k83, k84, k85, k86 }, \
        { 0, k91, k92, k93, k94, k95, k96 }, \
        { 0, 0, ka2, ka3, ka4, ka5, ka6 }, \
        { 0, 0, 0, kb3, kb4, kb5, kb6 } \
    }

    #define LAYOUT( \
      k00, \
      k10, k11, k12, \
      k20, k21, k22 \
    ) \
    { \
      { k00, 0, 0 }, \
      { k10, k11, k12 }, \
      { k20, k21, k22 } \
    }
    LAYOUT_STUB

    STUB_PATH="$out/stubs/layout_stubs.h"

    echo "Generating .clangd file..."
    # Choose system include root based on platform
    SYS_INC=${
      if pkgs.stdenv.isLinux then "\"${pkgs.glibc.dev}/include\"" else "\"${pkgs.apple-sdk}/usr/include\""
    }

    cat > $out/.clangd <<EOF
    CompileFlags:
      Add:
        - -ferror-limit=0
        - -x
        - c
        - -resource-dir=${pkgs.clang}/resource-root
        - -isystem
        - ${pkgs.clang}/resource-root/include
        - -isystem
        - $SYS_INC

        # Standard C types (avoid missing typedef noise)
        - -Duint8_t=unsigned char
        - -Duint16_t=unsigned short
        - -Duint32_t=unsigned int
        - -Duint64_t=unsigned long long
        - -Dint8_t=signed char
        - -Dint16_t=short
        - -Dint32_t=int
        - -Dint64_t=long long
        - -Dintmax_t=long long
        - -Duintmax_t=unsigned long long
        - -Dsize_t=unsigned long
        - -Dssize_t=long
        - -DUINT8_MAX=255
        - -DUINT16_MAX=65535
        - -Dbool=_Bool
        - -Dtrue=1
        - -Dfalse=0
        - -DNULL=((void*)0)

        # Stub highest priority
        - -I$out/stubs
        - -include$STUB_PATH

        # ChibiOS RTOS headers
        - -I${qmk-firmware}/lib/chibios/os/rt/include
        - -I${qmk-firmware}/lib/chibios/os/common/ports/ARMv7-M
        - -I${qmk-firmware}/platforms/chibios
        - -I${qmk-firmware}/platforms/chibios/boards/GENERIC_STM32_F303XC
        - -include${qmk-firmware}/platforms/chibios/boards/GENERIC_STM32_F303XC/configs/chconf.h
        - -include${qmk-firmware}/lib/chibios/os/rt/include/chtime.h
        - -DCH_CFG_ST_FREQUENCY=10000
        - -DCH_CFG_ST_RESOLUTION=32
        - -include${qmk-firmware}/platforms/chibios/boards/GENERIC_STM32_F303XC/configs/chconf.h
        - -include${qmk-firmware}/lib/chibios/os/rt/include/chtime.h

        # Timing stubs
        - -D_delay_ms(ms)=do{}while(0)
        - -D_delay_us(us)=do{}while(0)

        # Extra feature headers
        - -include${qmk-firmware}/quantum/leader.h
        - -include${qmk-firmware}/quantum/unicode/unicode.h
        - -include${qmk-firmware}/quantum/process_keycode/process_unicode_common.h
        - -include${qmk-firmware}/quantum/color.h
        - -include${qmk-firmware}/quantum/os_detection.h

        # Project (can overlay these paths locally when copying)
        - -I${qmk-firmware}
        - -I${qmk-firmware}/quantum

        # C standard
        - -std=gnu11

        # MCU defines (STM32F303 ONLY)
        - -DSTM32F303xC
        - -DSTM32F303CC
        - -DSTM32F3
        - -DSTM32F303
        - -DSTM32F30X
        - -DSTM32F3XX
        - -DSTM32
        - -DCORTEX_USE_FPU=TRUE
        - -DUSE_FPU=TRUE
        - -DARM_MATH_CM4

        # Block other STM32 families
        - -USTM32F0
        - -USTM32F0XX
        - -USTM32F0xx
        - -USTM32F1
        - -USTM32F1XX
        - -USTM32F2
        - -USTM32F4
        - -USTM32L0
        - -USTM32L0XX
        - -USTM32L0xx
        - -USTM32L1
        - -USTM32L4
        - -USTM32G0
        - -USTM32H7

        # Features
        - -DENCODER_ENABLE
        - -DENCODER_MAP_ENABLE
        - -DNUM_ENCODERS=1
        - -include${qmk-firmware}/quantum/encoder.h
        - -DRGB_MATRIX_ENABLE
        - -DRGB_MATRIX_LED_COUNT=72
        - -DAUDIO_ENABLE
        - -DTAP_DANCE_ENABLE
        - -DRAW_ENABLE
        - -DRAW_HID_ENABLE
        - -DSEND_STRING_ENABLE
        - -DMATRIX_ROWS=12
        - -DMATRIX_COLS=7
        - -DLEADER_ENABLE
        - -DUNICODE_ENABLE
        - -DOS_DETECTION_ENABLE

        # ChibiOS config
        - -DHAL_USE_I2C=TRUE
        - -DHAL_USE_SPI=TRUE
        - -DCHIBIOS_RT
    $QMK_INCLUDES

      Remove:
        - -mno-thumb-interwork
        - -mthumb
        - -mcpu=*
        - -march=*
        - -mfloat-abi=*
        - -mfpu=*
        - --target=arm-none-eabi
        - -mno-unaligned-access
        - -fsingle-precision-constant
        - -specs=*
        - --specs=*
        - -mmcu=*
        - -MD
        - -MP
        - -MF

    Diagnostics:
      Suppress:
        - init_element_not_constant
      UnusedIncludes: None

    Index:
      Background: Build
    EOF
  '';

  installPhase = ''
    # Nothing additional; buildPhase already created $out/.clangd and $out/stubs
    echo "Artifacts:"
    ls -R $out
  '';

  meta = {
    description = "Prebuilt .clangd config and Moonlander layout stub for QMK firmware development";
    license = pkgs.lib.licenses.mit;
    platforms = pkgs.lib.platforms.unix;
  };
}
