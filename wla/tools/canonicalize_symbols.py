#!/usr/bin/env python3
"""Render WLA child-label spelling in the project's canonical symbol form."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


LABEL = re.compile(r"^([0-9A-Fa-f]{2}:[0-9A-Fa-f]{4}\s+)(\S+)$")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()

    lines: list[str] = []
    for line in args.source.read_text().splitlines():
        match = LABEL.match(line)
        if match:
            line = match.group(1) + match.group(2).replace("@", ".")
        lines.append(line)
    args.output.write_text("\n".join(lines) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
