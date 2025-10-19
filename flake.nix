{
  description = "Moonlander MK II QMK Firmware";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # NB: This must be ZSA's fork, or you might lose the ability to connect to Oryx
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
        build = pkgs.callPackage ./nix/build.nix { };
        flash = pkgs.callPackage ./nix/flash.nix { };
        build_args = {
          inherit qmk-firmware;
          keyboard = "zsa/moonlander";
          src = ./src;
        };
        setup-lsp = import ./nix/setup-lsp.nix {
          inherit pkgs;
          inherit qmk-firmware;
        };
      in
      {
        packages = {
          default = build build_args;
          flash = flash build_args;
        };
        devShells.default = pkgs.mkShell {
          QMK_HOME = "${qmk-firmware}";
          packages = [
            pkgs.qmk
            setup-lsp
          ];
        };
      }
    );
}
