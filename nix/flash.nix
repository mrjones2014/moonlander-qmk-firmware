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

  firmwareDir = "${firmware}/bin";
  targetBase = build_args.targetName;
in
writeShellScriptBin "flash" ''
  set -euo pipefail

  dir="${firmwareDir}"
  base="${targetBase}"
  kb="${build_args.keyboardVariant}"

  pick_fw() {
    if   [ -f "$dir/$base.uf2" ]; then echo "$dir/$base.uf2"
    elif [ -f "$dir/$base.hex" ]; then echo "$dir/$base.hex"
    elif [ -f "$dir/$base.bin" ]; then echo "$dir/$base.bin"
    else
      echo "No firmware artifact found for '$base' in '$dir' (.uf2/.hex/.bin)." >&2
      exit 1
    fi
  }

  fw="$(pick_fw)"
  echo "Using firmware: $fw"
  echo "Waiting for keyboard in bootloader mode..."
  echo "(Press your reset button now)"

  # Let QMK handle the actual flashing once we select the right artifact.
  "${qmk}/bin/qmk" flash "$fw" --keyboard "${build_args.keyboardVariant}" \
    && echo "✓ Flash complete!"
''
