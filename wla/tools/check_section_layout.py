#!/usr/bin/env python3
"""Check the committed native ROM section placement against WLALINK output."""

from __future__ import annotations

import argparse
import csv
import re
from pathlib import Path


SECTION = re.compile(
    r"^[0-9a-fA-F]{8}\s+([0-9a-fA-F]{2}):([0-9a-fA-F]{4})\s+"
    r"[0-9a-fA-F]{4}\s+([0-9a-fA-F]{8})\s+(.+)$"
)
LABEL = re.compile(r"^([0-9a-fA-F]{2}):([0-9a-fA-F]{4})\s+(\S+)$")


def linked_sections(lines: list[str]) -> dict[str, tuple[int, int, int]]:
    start = lines.index("[sections]") + 1
    result: dict[str, tuple[int, int, int]] = {}
    for line in lines[start:]:
        if not line or line.startswith("["):
            break
        match = SECTION.match(line)
        if not match:
            raise ValueError(f"unrecognized WLALINK section row: {line}")
        bank = int(match.group(1), 16)
        origin = int(match.group(2), 16)
        size = int(match.group(3), 16)
        result[match.group(4)] = (bank, origin, size)
    return result


def linked_labels(lines: list[str]) -> dict[str, tuple[int, int]]:
    result: dict[str, tuple[int, int]] = {}
    for line in lines:
        match = LABEL.match(line)
        if match:
            name = match.group(3).replace("@", ".")
            result[name] = (int(match.group(1), 16), int(match.group(2), 16))
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("symbols", type=Path)
    parser.add_argument("layout", type=Path)
    args = parser.parse_args()

    symbol_lines = args.symbols.read_text().splitlines()
    actual = linked_sections(symbol_lines)
    labels = linked_labels(symbol_lines)
    expected: dict[str, tuple[int, int, int]] = {}
    failures: list[str] = []

    with args.layout.open(newline="") as source:
        for row in csv.DictReader(source, delimiter="\t"):
            name = row["section"]
            bank = int(row["bank"], 16)
            slot = int(row["slot"])
            origin = int(row["origin"], 16)
            size = int(row["size"], 16)
            expected[name] = (bank, origin, size)
            if slot != (0 if bank == 0 else 1):
                failures.append(f"{name}: invalid slot {slot} for bank {bank:02x}")
            if row["status"] != "converted":
                failures.append(f"{name}: conversion status is {row['status']!r}")
            if not Path(row["source_owner"]).is_file():
                failures.append(f"{name}: missing source owner {row['source_owner']}")
            start = origin if bank == 0 else 0x4000 + origin
            end = start + size
            for key in ("first_symbol", "last_symbol"):
                symbol = row[key]
                if symbol == "-":
                    continue
                address = labels.get(symbol)
                if address is None:
                    failures.append(f"{name}: missing {key} {symbol}")
                elif address[0] != bank or not start <= address[1] < max(end, start + 1):
                    failures.append(f"{name}: {symbol} is outside the committed section")

    for name in sorted(expected.keys() - actual.keys()):
        failures.append(f"missing linked section: {name}")
    for name in sorted(actual.keys() - expected.keys()):
        failures.append(f"uncommitted linked section: {name}")
    for name in sorted(expected.keys() & actual.keys()):
        if expected[name] != actual[name]:
            failures.append(
                f"{name}: expected {expected[name]}, linked {actual[name]}"
            )

    if failures:
        for failure in failures:
            print(failure)
        return 1
    print(f"all {len(expected)} native ROM sections match the committed layout")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
