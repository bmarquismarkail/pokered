# Pokémon Red [![Build Status][ci-badge]][ci]

This is a native WLA-DX disassembly of Pokémon Red.

It builds:

- Pokemon Red (UE) [S][!].gb `sha1: ea9bcae617fdf159b045185467ae58b2e4a48b9a`

To set up the repository, see [**INSTALL.md**](INSTALL.md).

Run `make` or `make red` to build it. `make check` performs a clean native build,
verifies the ROM and every bank, audits the committed section layout and source
syntax, and compares all linked symbols with the validation-only reference table.


## See also

- [**Wiki**][wiki] (includes [tutorials][tutorials])
- [**Symbols**][symbols]
- [**Tools**][tools]

You can find us on [Discord (pret, #pokered)](https://discord.gg/d5dubZ3).

For other pret projects, see [pret.github.io](https://pret.github.io/).

[wiki]: https://github.com/pret/pokered/wiki
[tutorials]: https://github.com/pret/pokered/wiki/Tutorials
[symbols]: https://github.com/pret/pokered/tree/symbols
[tools]: https://github.com/pret/gb-asm-tools
[ci]: https://github.com/pret/pokered/actions
[ci-badge]: https://github.com/pret/pokered/actions/workflows/main.yml/badge.svg
