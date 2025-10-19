{
  lib,
  qmk,
  stdenv,
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
  build_args = (import ./build-args.nix { inherit lib; }) { inherit keyboard variant target; };
in
stdenv.mkDerivation {
  name = "${build_args.keymapName}-firmware";
  src = qmk-firmware;
  buildInputs = [ qmk ];

  postPatch = ''
    mkdir -p ${build_args.keymapDir}
    cp -r ${src}/* ${build_args.keymapDir}/
  '';

  buildPhase = ''
    qmk compile \
        --env SKIP_GIT=true \
        --env QMK_HOME=$PWD \
        --env QMK_FIRMWARE=$PWD \
        --env BUILD_DIR=${build_args.buildDir} \
        --env TARGET=${build_args.targetName} \
        --keyboard ${build_args.keyboardVariant} \
        --keymap ${build_args.keymapName} \
        --compiledb
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${build_args.buildDir}/*.{hex,bin,elf,dfu,uf2,eep} $out/bin 2>/dev/null || true
    cp compile_commands.json $out/
  '';

  dontFixup = true;
}
