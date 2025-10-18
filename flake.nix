{
  description = "Moonlander MK II QMK Firmware";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    qmk-firmware = {
      flake = false;
      url = "https://github.com/zsa/qmk_firmware.git";
      ref = "firmware25";
      type = "git";
      submodules = true;
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      qmk-firmware,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        build = import ./build.nix { inherit (pkgs) lib stdenv qmk; };
      in
      {
        packages.default = build {
          inherit qmk-firmware;
          keyboard = "zsa/moonlander";
          src = ./src;
        };
      }
    );
}
