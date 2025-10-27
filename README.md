# Custom QMK Firmwares

Custom, out-of-tree QMK firmwares, with `clangd` LSP setup.

- ZSA Moonlander MK I
  - Cross-OS shortcuts (ctrl vs. cmd shortcuts on Linux vs. macOS)
- TogKey Pad Plus

## Features

- **Cross-OS Shortcuts**: Same physical keys adapt to macOS (CMD) vs Linux (CTRL) automatically using QMK's OS detection.
- **LSP setup**: Autocomplete and type checking for QMK firmware development.
  - The `devShell` sets up a `.clangd` file in the proeject root (`.gitignored`)
  - This sets up a bunch of path hacks required since the code is not nested inside the `qmk_firmware` tree, so it references `/nix/store/*` paths
- **Nix-managed**: Reproducible builds, all dependencies handled auatomatically
  - This works by essentially patching your configuration into the `qmk_firmware` tree at build time
  - See [build.nix](https://github.com/mrjones2014/moonlander-qmk-firmware/blob/master/nix/build.nix)
  - This is _loosely_ based on [Nixcaps](https://github.com/agustinmista/nixcaps)

## Quick Start

You can use `direnv` to manage the Nix `devShell`. I highly recommend using [nix-direnv](https://github.com/nix-community/nix-direnv).

```bash
direnv allow
# from now on, the devShell will activate whenever you `cd` into the project
# the repo root should have an auto-generated .clangd config file
nvim src/keymap.c
```

## Build

Building the firmware is a Nix derivation:

```bash
nix build .#moonlander.build
nix build .#togkey.build
# outputs to ./result/bin/*
```

You can also build + flash the firmware in one step by running:

```bash
nix run .#moonlander.flash
nix run .#togkey.flash
```
