{
  lib,
  qmk,
  stdenv,
  writeShellScriptBin,
  ...
}:
{
  qmk-firmware,
  src,
  keyboard,
  variant ? null,
  target ? null,
}:
let
  firmware = (import ./build.nix { inherit lib qmk stdenv; }) {
    inherit
      qmk-firmware
      src
      keyboard
      variant
      target
      ;
  };
  build_args = (import ./build-args.nix { inherit lib; }) { inherit keyboard variant target; };
  # Parse keyboard.json to determine bootloader type
  keyboardJson = builtins.fromJSON (
    builtins.readFile "${qmk-firmware}/${build_args.keyboardDir}/keyboard.json"
  );
  bootloader = keyboardJson.bootloader or "unknown";

  # Map bootloader to file extension
  fileExtension =
    if
      bootloader == "caterina" # Arduino/AVR
      || bootloader == "atmel-dfu" # AVR DFU
      || bootloader == "halfkay" # Teensy
      || bootloader == "qmk-dfu" # QMK DFU (AVR)
      || bootloader == "usbasploader" # USBasp
      || bootloader == "bootloadhid" # bootloadHID
    then
      "hex"
    else if lib.hasInfix "rp2040" bootloader then
      "uf2" # RP2040
    else
      "bin";
  firmware_bin = "${firmware}/bin/${build_args.targetName}.${fileExtension}";
in
writeShellScriptBin "flash" ''
  set -e

  echo "Waiting for keyboard in bootloader mode..."
  echo "(Press your reset button now)"

  # qmk flash auto-detects bootloader from keyboard.json
  ${qmk}/bin/qmk flash ${firmware_bin} \
    --keyboard ${build_args.keyboardVariant}

  echo "✓ Flash complete!"
''
