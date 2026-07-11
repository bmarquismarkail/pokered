#!/usr/bin/env python3
"""Convert RGBDS music headers to WLA-DX using addresses from an RGBDS sym file."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


LABEL = re.compile(r"^((?:Music|SFX)_[A-Za-z0-9_]+)::$")
COUNT = re.compile(r"^\s*channel_count\s+([1-4])$")
CHANNEL = re.compile(r"^\s*channel\s+([1-8]),\s*((?:Music|SFX)_[A-Za-z0-9_]+)$")
PADDING = re.compile(r"^\s*db\s+\$ff,\s*\$ff,\s*\$ff$")


def symbols(path: Path) -> dict[str, int]:
    result = {}
    for raw in path.read_text().splitlines():
        match = re.match(r"[0-9a-fA-F]{2}:([0-9a-fA-F]{4})\s+(\S+)$", raw)
        if match:
            result[match.group(2)] = int(match.group(1), 16)
    return result


def convert(source: Path, sym: Path, end_label: str) -> str:
    addresses = symbols(sym)
    output = [f"; Generated from {source} by convert_music_headers.py.", ""]
    pending_count = None
    headers = 0
    for line_number, raw in enumerate(source.read_text().splitlines(), 1):
        line = raw.split(";", 1)[0].strip()
        if not line:
            continue
        label = LABEL.fullmatch(line)
        if label:
            output.append(f"{label.group(1)}:")
            headers += 1
            continue
        count = COUNT.fullmatch(line)
        if count:
            pending_count = int(count.group(1))
            continue
        if PADDING.fullmatch(line):
            output.append("\t.DB $ff, $ff, $ff")
            continue
        channel = CHANNEL.fullmatch(line)
        if channel:
            channel_id = int(channel.group(1))
            target = channel.group(2)
            if target not in addresses:
                raise ValueError(f"{sym}: missing {target}")
            header_bits = ((pending_count - 1) << 6) if pending_count is not None else 0
            output.extend((f"\t.DB ${header_bits | channel_id - 1:02x}", f"\t.DW ${addresses[target]:04x} ; {target}"))
            pending_count = None
            continue
        raise ValueError(f"{source}:{line_number}: unsupported line: {raw}")
    if headers == 0:
        raise ValueError("no music headers found")
    output.extend((f"{end_label}:", ""))
    return "\n".join(output)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("sym", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("end_label")
    args = parser.parse_args()
    args.output.write_text(convert(args.source, args.sym, args.end_label))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
