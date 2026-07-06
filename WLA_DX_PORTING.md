# WLA-DX Structured Port

This branch preserves the `master` source tree. File layout, include topology, assets, docs, and the normal RGBDS build remain the source of truth.

`wla/` contains WLA-DX scaffold files and translated proof-of-concept units. It is not a replacement source tree.

`make wla-poc` is a minimal WLA-DX smoke test. It assembles and links a tiny standalone Game Boy ROM at `wla/build/home_start_poc.gb`; it does not build the full Pokemon Red ROM.

The old monolithic `wla-dx` branch is reference material only. It may be useful for WLA-DX syntax or known translated fragments, but its container-style layout is not the desired repository layout.

## First structured unit proof of concept

`make wla-unit-poc` assembles and links a WLA-DX translation of one real `master` unit:

- Source unit: `data/moves/field_move_names.asm`
- WLA translation: `wla/data/moves/field_move_names.asm`
- Driver: `wla/poc/field_move_names_poc_driver.asm`
- Link file: `wla/unit_poc.link`
- Drift check: `make wla-check-field-move-names`

This file was chosen because it is a small data-only table: one label plus field-move name bytes, with no code flow, local labels, macros, includes, bank placement, or gameplay logic. Its only non-local translation concern is the Pokemon text charmap, so the WLA file expands the original string literals into explicit byte values from `constants/charmap.asm` (`A` = `$80`, `@` = `$50`, etc.).

The target is intentionally standalone. It proves that one preserved-layout master-tree unit can live under `wla/` and pass through `wla-gb`/`wlalink` without changing the normal RGBDS source files or broadening into a full port.

`make wla-check-field-move-names` runs `wla/tools/check_field_move_names.py`. The script is intentionally narrow: it encodes the expected Pokemon charmap bytes for the current `FieldMoveNames` strings and compares them with the `.DB` bytes in `wla/data/moves/field_move_names.asm`, so this first translated unit cannot silently drift from the RGBDS source expectation.
