#!/usr/bin/env python3
"""Reject RGBDS-only syntax and migration-scaffold dependencies.

This is intentionally a lexical gate, not an assembler.  It catches constructs
which cannot appear in the completed native WLA-DX tree and prints every source
location so conversion can proceed in small, reviewable batches.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path


RGBDS_DIRECTIVE = re.compile(
    r"^\s*(?:SECTION|DEF|REDEF|PURGE|EXPORT|GLOBAL|CHARMAP|NEWCHARMAP|"
    r"SETCHARMAP|PUSHC|POPC|UNION|NEXTU|ENDU|LOAD|ENDL|FOR|ENDC|"
    r"FAIL|RSRESET|RSSET)\b",
    re.IGNORECASE,
)
DOUBLE_COLON = re.compile(r"^[^;]*\b[A-Za-z_][\w.#@]*::")
FORBIDDEN_INCLUDE = re.compile(
    r"\bINCLUDE\s+[\"'](?:wla/(?:banks|pkrd)/|[^\"']*generated[^\"']*\.asm)",
    re.IGNORECASE,
)
RGBDS_EXPRESSION = re.compile(r"\b(?:EQU|EQUS)\b|\bDEF\s*\(|\{(?:0?2)?d:")
UNQUALIFIED_LOCAL = re.compile(r"^\s*\.[A-Za-z_][A-Za-z0-9_]*\s*:")
DIRECT_DB_STRING = re.compile(r'^\s*\.DB\b[^;]*"', re.IGNORECASE)
QUOTED_STRING = re.compile(r'"(?:\\.|[^"\\])*"')


def assembly_files(root: Path) -> list[Path]:
    return sorted(
        path
        for path in root.rglob("*")
        if path.suffix in {".asm", ".inc"}
        if ".git" not in path.parts and not path.is_relative_to(root / "wla" / "reference")
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", nargs="?", type=Path, default=Path("."))
    args = parser.parse_args()
    root = args.root.resolve()
    failures: list[tuple[Path, int, str]] = []

    for path in assembly_files(root):
        relative = path.relative_to(root)
        for number, line in enumerate(path.read_text(errors="replace").splitlines(), 1):
            code = line.split(";", 1)[0]
            expression = QUOTED_STRING.sub('""', code)
            if RGBDS_DIRECTIVE.search(code):
                failures.append((relative, number, "RGBDS directive"))
            elif DOUBLE_COLON.search(code):
                failures.append((relative, number, "RGBDS exported label (::)"))
            elif FORBIDDEN_INCLUDE.search(code):
                failures.append((relative, number, "forbidden generated/scaffold include"))
            elif RGBDS_EXPRESSION.search(code):
                failures.append((relative, number, "RGBDS expression/interpolation"))
            elif UNQUALIFIED_LOCAL.search(code):
                failures.append((relative, number, "unqualified RGBDS local label"))
            elif DIRECT_DB_STRING.search(code):
                failures.append((relative, number, "direct string in .DB; use .STRINGMAP"))
            elif "^" in expression:
                failures.append((relative, number, "RGBDS xor operator (^); WLA-DX uses ~"))

    for path, number, reason in failures:
        print(f"{path}:{number}: {reason}")
    if failures:
        print(f"native source audit failed: {len(failures)} unsupported constructs")
        return 1
    print("native source audit passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
