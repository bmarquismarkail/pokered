# Native WLA-DX port

Pokémon Red is assembled directly from the repository's root source hierarchy
with WLA-DX. `home.asm`, `main.asm`, `maps.asm`, `audio.asm`, `text.asm`, the
three graphics roots, and `ram.asm` remain independent objects. No generated
assembly, copied banks, or reference ROM is part of the build.

The native support files are deliberately small:

- `wla/native/config.asm` defines the Game Boy ROM/RAM memory model.
- `wla/native/pokered.link` defines the nine-object link.
- `wla/native/section_layout.tsv` commits every ROM section's owner, bank,
  slot, origin, size, boundary symbols, and conversion status.
- `wla/reference/pokered.sym` is an optional validation oracle. `make red`
  neither opens nor depends on it.
- `wla/tools/` contains the source, layout, bank, ROM, and symbol audits.

The Game Boy cartridge header, Nintendo logo, cartridge/RAM/ROM metadata,
header complement, and global checksum are emitted by WLA-DX. Text remains in
readable strings through the checked `pokemon` string map. WLA child labels are
rendered as the project's established `Parent.child` symbol spelling after the
link; addresses are never supplied by the symbol oracle.

PNG conversion is implemented by `tools/png2gb.py` using only the Python
standard library. It supports the repository's non-interlaced 1-bit and 2-bit
grayscale inputs, 1bpp/2bpp Game Boy planar output, and column-major tiles.
The existing `tools/gfx` transformations and `tools/pkmncompress` compression
remain in the pipeline.

## Commands

```text
make              build the native Red ROM
make red          build the native Red ROM
make check        clean-build and run every acceptance check
make check-symbols compare linked symbols with wla/reference/pokered.sym
make clean        remove objects, ROMs, symbols, tools, and generated graphics
```

The accepted ROM is exactly 1 MiB with SHA-1
`ea9bcae617fdf159b045185467ae58b2e4a48b9a`.
