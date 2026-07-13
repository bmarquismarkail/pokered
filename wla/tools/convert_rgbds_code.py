#!/usr/bin/env python3
"""Convert the common RGBDS instruction/local-label subset to WLA-DX syntax.

This deliberately rejects source directives and project macros. Callers must
expand those explicitly so unsupported constructs cannot silently change bytes.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path


LOCAL_RE = re.compile(r'(?<![A-Za-z0-9_])\.([A-Za-z_][A-Za-z0-9_]*)')
LABEL_RE = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*)(?:::|:)$')
LOCAL_LABEL_RE = re.compile(r'^\.([A-Za-z_][A-Za-z0-9_]*):?$')
UNSUPPORTED_RE = re.compile(
    r'^\s*(?:INCLUDE|REPT|ENDR|IF|ELSE|ENDC|ASSERT|DEF|MACRO|ENDM|'
    r'db|dw|ds|dba|dbw|callfar|farcall|jpfar|predef(?:_jump)?)\b',
    re.IGNORECASE,
)


def load_symbols(path: Path | None) -> dict[str, tuple[int, int]]:
    symbols: dict[str, tuple[int, int]] = {}
    if path is None:
        return symbols
    for line in path.read_text().splitlines():
        match = re.match(r'^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4}) (\S+)$', line)
        if match:
            symbols[match.group(3)] = (int(match.group(1), 16), int(match.group(2), 16))
    return symbols


def convert(paths: list[Path], symbols: dict[str, tuple[int, int]]) -> str:
    output: list[str] = []
    current_global: str | None = None
    for path in paths:
        for raw in path.read_text().splitlines():
            code, separator, comment = raw.partition(';')
            stripped = code.strip()
            if not stripped:
                output.append(raw)
                continue
            global_label = LABEL_RE.match(stripped)
            if global_label:
                current_global = global_label.group(1)
                converted = f'{current_global}:'
            else:
                local_label = LOCAL_LABEL_RE.match(stripped)
                if local_label:
                    if current_global is None:
                        raise ValueError(f'{path}: local label before global label: {stripped}')
                    converted = f'{current_global}.{local_label.group(1)}:'
                else:
                    macro = re.match(r'^(farcall|callfar|farjp|jpfar)\s+([A-Za-z_][A-Za-z0-9_]*)$', stripped)
                    predef = re.match(r'^(predef|predef_jump)\s+([A-Za-z_][A-Za-z0-9_]*)$', stripped)
                    text_far = re.match(r'^text_far\s+([A-Za-z_][A-Za-z0-9_]*)$', stripped)
                    if macro:
                        kind, target = macro.groups()
                        bank, address = symbols[target]
                        jump = 'jp' if kind in {'farjp', 'jpfar'} else 'call'
                        if kind in {'farcall', 'farjp'}:
                            converted = f'\tld b, ${bank:02x}\n\tld hl, ${address:04x}\n\t{jump} Bankswitch'
                        else:
                            converted = f'\tld hl, ${address:04x}\n\tld b, ${bank:02x}\n\t{jump} Bankswitch'
                    elif predef:
                        kind, target = predef.groups()
                        _, base = symbols['PredefPointers']
                        _, entry = symbols[target + 'Predef']
                        predef_id = (entry - base) // 3
                        jump = 'jp' if kind == 'predef_jump' else 'call'
                        converted = f'\tld a, ${predef_id:02x}\n\t{jump} Predef'
                    elif text_far:
                        target = text_far.group(1)
                        bank, address = symbols[target]
                        converted = f'\t.DB $17\n\t.DW ${address:04x}\n\t.DB ${bank:02x}'
                    elif stripped == 'text_asm':
                        converted = '\t.DB $08'
                    elif stripped == 'text_end':
                        converted = '\t.DB $50'
                    elif stripped == 'sound_level_up':
                        converted = '\t.DB $0b'
                    elif UNSUPPORTED_RE.match(stripped):
                        raise ValueError(f'{path}: unsupported construct: {stripped}')
                    elif current_global is None:
                        raise ValueError(f'{path}: instruction before global label: {stripped}')
                    else:
                        converted = LOCAL_RE.sub(lambda m: f'{current_global}.{m.group(1)}', stripped)
                        converted = re.sub(r'\[hli\]', '(HL+)', converted, flags=re.IGNORECASE)
                        converted = re.sub(r'\[hld\]', '(HL-)', converted, flags=re.IGNORECASE)
                        converted = re.sub(r'\[([^\]]+)\]', r'(\1)', converted)
                        converted = re.sub(
                            r'\((h[A-Z][A-Za-z0-9_]*)([^)]*)\)',
                            r'(\1 - $FF00\2)',
                            converted,
                        )
                        converted = '\t' + converted
            if separator:
                converted += f' ;{comment}'
            output.append(converted)
    return '\n'.join(output) + '\n'


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('--symbols', type=Path)
    parser.add_argument('sources', nargs='+', type=Path)
    args = parser.parse_args()
    print(convert(args.sources, load_symbols(args.symbols)), end='')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
