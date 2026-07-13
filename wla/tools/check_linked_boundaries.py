#!/usr/bin/env python3
"""Verify linked addresses and sizes of structured WLA-DX sections."""

from __future__ import annotations

import re
import sys
from pathlib import Path


EXPECTED = (
    ('Doors and Ledges', 0x06, 'PlayerStepOutFromDoor', 0x63E0, 'DoorsAndLedgesEnd', 0x6718),
    ('Hidden Events 1', 0x07, 'OpenOaksPC', 0x6915, 'HiddenEvents1End', 0x6CC2),
    ('Battle Engine 10', 0x16, 'PrintBeginningBattleText', 0x4D99, 'BattleEngine10End', 0x50B0),
    ('Hidden Events 3', 0x17, 'SetPartyMonTypes', 0x5B5E, 'HiddenEvents3End', 0x5F15),
    ('Itemfinder 2', 0x1D, 'PKMNLeaguePC', 0x657E, 'Itemfinder2End', 0x687B),
)


def main() -> int:
    symbols: dict[str, tuple[int, int]] = {}
    for line in Path(sys.argv[1]).read_text().splitlines():
        match = re.match(r'^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4}) (\S+)$', line)
        if match:
            symbols[match.group(3)] = (int(match.group(1), 16), int(match.group(2), 16))
    for description, bank, start_label, start, end_label, end in EXPECTED:
        if symbols.get(start_label) != (bank, start) or symbols.get(end_label) != (bank, end):
            print(f'FAIL linked boundary changed for {description}')
            return 1
        print(f'OK linked {description}: bank {bank:02x}, {end - start}-byte boundary')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
