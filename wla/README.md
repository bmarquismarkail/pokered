# WLA-DX support

This directory supports the native source build; it does not contain a second
copy of the game.

- `native/` contains the memory map, linker object list, RAM constants, and
  committed section layout.
- `reference/pokered.sym` is used only by `make check-symbols`.
- `tools/` contains deterministic validation and symbol-format helpers.

The production build begins at the root assembly files listed in the Makefile.
No file under `reference/` is read by `make` or `make red`.
