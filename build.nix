{
  lib,
  qmk,
  stdenv,
  ...
}:
{
  qmk-firmware,
  keyboard,
  src,
  target ? null,
  variant ? null,
  ...
}:
let
  buildDir = "build";
  keyboardDir = "keyboards/${keyboard}";
  keyboardVariant = if builtins.isNull variant then "${keyboard}" else "${keyboard}/${variant}";
  keyboardName = lib.last (lib.splitString "/" keyboard);
  keymapName = "${keyboardName}-default";
  keymapDir = "${keyboardDir}/keymaps/${keymapName}";
  targetName = if builtins.isNull target then "${keymapName}" else target;
in
stdenv.mkDerivation {
  name = "${keymapName}-firmware-compile";
  src = qmk-firmware;
  buildInputs = [ qmk ];
  postPatch = ''
    mkdir -p ${keymapDir}
    cp -r ${src}/* ${keymapDir}/
  '';
  buildPhase = ''
    ls -la ${keymapDir}
    qmk compile \
        --env SKIP_GIT=true \
        --env QMK_HOME=$PWD \
        --env QMK_FIRMWARE=$PWD \
        --env BUILD_DIR=${buildDir} \
        --env TARGET=${targetName} \
        --keyboard ${keyboardVariant} \
        --keymap ${keymapName}
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp ${buildDir}/*.{hex,bin,elf,dfu,uf2,eep} $out/bin
  '';
  dontFixup = true;
}
