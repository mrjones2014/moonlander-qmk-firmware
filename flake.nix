{
  description = "Moonlander MK II QMK Firmware";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    qmk-firmware = {
      flake = false;
      url = "https://github.com/qmk/qmk_firmware.git";
      ref = "0.30.6";
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
        build = pkgs.callPackage ./nix/build.nix { };
        flash = pkgs.callPackage ./nix/flash.nix { };
        keyboards = {
          moonlander = {
            inherit qmk-firmware;
            keyboard = "zsa/moonlander";
            src = ./src/moonlander;
          };
          togkey_pad_plus = {
            inherit qmk-firmware;
            keyboard = "togkey/pad_plus";
            src = ./src/togkey_pad_plus;
          };
        };
        clangd-config = import ./nix/clangd-config.nix {
          inherit pkgs;
          inherit qmk-firmware;
        };
      in
      {
        packages = {
          moonlander = {
            build = build keyboards.moonlander;
            flash = flash keyboards.moonlander;
          };
          togkey = {
            build = build keyboards.togkey_pad_plus;
            flash = flash keyboards.togkey_pad_plus;
          };
        };
        devShells.default = pkgs.mkShell {
          QMK_HOME = "${qmk-firmware}";
          packages = [
            pkgs.qmk
          ];
          shellHook = ''
            ln -sf "${clangd-config}/.clangd" .clangd
          '';
        };
      }
    );
}
