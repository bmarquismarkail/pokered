# WLA-DX Structured Port

This branch preserves the `master` source tree. File layout, include topology, assets, docs, and the normal RGBDS build remain the source of truth.

`wla/` contains only WLA-DX scaffold files for now. It is not a replacement source tree.

`make wla-poc` is a minimal WLA-DX smoke test. It assembles and links a tiny standalone Game Boy ROM at `wla/build/home_start_poc.gb`; it does not build the full Pokemon Red ROM.

The old monolithic `wla-dx` branch is reference material only. It may be useful for WLA-DX syntax or known translated fragments, but its container-style layout is not the desired repository layout.

Next step: convert one real, small assembly unit from the `master` tree while preserving the existing file organization.
