#!/usr/bin/env python3
"""Compare WLA's linked labels with the committed RGBDS address oracle."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


LABEL = re.compile(r"^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4})\s+(\S+)$")


def load(path: Path) -> dict[str, tuple[int, int]]:
    result: dict[str, tuple[int, int]] = {}
    for line in path.read_text().splitlines():
        match = LABEL.match(line)
        if match:
            result[match.group(3)] = (int(match.group(1), 16), int(match.group(2), 16))
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--linked-subset', action='store_true')
    parser.add_argument('--ignore-prefix', action='append', default=[])
    parser.add_argument('linked', type=Path)
    parser.add_argument('reference', type=Path)
    args = parser.parse_args()
    linked = load(args.linked)
    reference = load(args.reference)
    if args.ignore_prefix:
        linked = {
            name: address
            for name, address in linked.items()
            if not name.startswith(tuple(args.ignore_prefix))
        }
    missing = [] if args.linked_subset else sorted(reference.keys() - linked.keys())
    wrong = sorted(name for name in reference.keys() & linked.keys() if reference[name] != linked[name])
    unknown = sorted(linked.keys() - reference.keys()) if args.linked_subset else []
    for name in missing[:50]:
        print(f"missing: {name}", file=sys.stderr)
    for name in wrong[:50]:
        print(f"wrong: {name}: expected {reference[name]}, got {linked[name]}", file=sys.stderr)
    for name in unknown[:50]:
        print(f"unknown: {name}", file=sys.stderr)
    if missing or wrong or unknown:
        print(
            f"symbol audit failed: {len(missing)} missing, {len(wrong)} wrong, {len(unknown)} unknown",
            file=sys.stderr,
        )
        return 1
    if args.linked_subset:
        print(f"all {len(linked)} linked symbols match the reference")
    else:
        print(f"all {len(reference)} reference symbols match")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
