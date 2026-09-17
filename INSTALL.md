# Build instructions

The native Pokémon Red build requires:

- GNU Make and standard host utilities
- WLA-DX (`wla-gb` and `wlalink`)
- Python 3
- a C17 compiler for the project-local graphics tools

RGBDS and third-party Python imaging libraries are not required.

On Debian or Ubuntu, install the host dependencies and a pinned WLA-DX
release with:

```bash
sudo apt-get install build-essential cmake curl make python3
tmpdir="$(mktemp -d)"
curl -L https://github.com/vhelin/wla-dx/archive/refs/tags/v10.7.tar.gz -o "$tmpdir/wla-dx.tar.gz"
tar -xzf "$tmpdir/wla-dx.tar.gz" -C "$tmpdir"
cmake -S "$tmpdir/wla-dx-10.7" -B "$tmpdir/build"
cmake --build "$tmpdir/build"
sudo cmake --install "$tmpdir/build"
rm -rf "$tmpdir"
```

On macOS with Homebrew:

```bash
brew install make python wla-dx
```

Then clone the repository and build Red:

```bash
git clone https://github.com/pret/pokered
cd pokered
make red
```

`make` is equivalent to `make red`. To perform a clean reproducibility build,
ROM hash and bank checks, section-layout validation, source-syntax validation,
and the optional reference-symbol comparison, run:

```bash
make check
```

The result is `pokered.gbc`, exactly 1 MiB with SHA-1
`ea9bcae617fdf159b045185467ae58b2e4a48b9a`.
