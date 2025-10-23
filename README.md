# Moonlander MK I Custom QMK Firmware

Custom, out-of-tree QMK firmware for ZSA Moonlander with cross-OS shortcuts, and full LSP support in Neovim.

## Features

- **Cross-OS Shortcuts**: Same physical keys adapt to macOS (CMD) vs Linux (CTRL) automatically using QMK's OS detection.
- **LSP setup**: Autocomplete and type checking for QMK firmware development.
  - Run `setup-lsp` after activating the Nix `devShell` provided by `flake.nix`
  - This sets up a bunch of path hacks required since the code is not nested inside the `qmk_firmware` tree
- **Nix-managed**: Reproducible builds, all dependencies handled auatomatically
  - This works by essentially patching your configuration into the `qmk_firmware` tree at build time
  - See [build.nix](https://github.com/mrjones2014/moonlander-qmk-firmware/blob/master/nix/build.nix)
  - This is _loosely_ based on [Nixcaps](https://github.com/agustinmista/nixcaps)

## Quick Start

You can use `direnv` to manage the Nix `devShell`. I highly recommend using [nix-direnv](https://github.com/nix-community/nix-direnv).

```bash
direnv allow
# from now on, the devShell will activate whenever you `cd` into the project
setup-lsp
# should auto-generate .clangd and some stubs
# you only need to run this once, unless `qmk_firmware` is updated in flake.lock
nvim src/keymap.c
```

## Build

Building the firmware is a Nix derivation:

```bash
nix build
# outputs to ./result/bin/moonlander-default.{bin,elf,hex}
```

You can also build + flash the firmware in one step by running:

```bash
nix build .#flash
```

## Project structure

```
├── flake.nix         # devShell and package builds
├── nix
│   ├── build.nix     # Nix build derivation
│   └── setup-lsp.nix # Setup LSP path hacks
├── README.md
└── src               # See QMK docs for more details on these files
    ├── config.h      # Config overrides
    ├── keymap.c      # Keymap implementation
    ├── keymap.json   # Custom modules etc.
    └── rules.mk      # Custom build rules
```
