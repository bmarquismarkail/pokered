#!/usr/bin/env python3
"""Convert the common RGBDS instruction/local-label subset to WLA-DX syntax.

It expands the small, audited macro subset used by migrated executable sections
and rejects everything else so unsupported constructs cannot silently change
bytes.
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
    r'ds|dba|callfar|farcall|jpfar|predef(?:_jump)?)\b',
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


def load_defines(path: Path | None) -> dict[str, int]:
    values: dict[str, int] = {}
    if path is None:
        return values
    for line in path.read_text().splitlines():
        match = re.match(r'^\.DEFINE\s+(\w+)\s+([-$0-9A-Fa-fx]+)$', line)
        if match:
            value = match.group(2).replace('$', '0x')
            values[match.group(1)] = int(value, 0)
    return values


def qualify(value: str, current_global: str | None) -> str:
    if current_global is None:
        return value
    return LOCAL_RE.sub(lambda match: f'{current_global}.{match.group(1)}', value)


def operands(value: str) -> list[str]:
    return [part.strip() for part in value.split(',')]


def expanded_lines(paths: list[Path]):
    for path in paths:
        for raw in path.read_text().splitlines():
            code = raw.partition(';')[0].strip()
            include = re.match(r'^INCLUDE\s+"([^"]+)"$', code, re.IGNORECASE)
            if include:
                yield from expanded_lines([Path(include.group(1))])
            else:
                yield path, raw


def convert(paths: list[Path], symbols: dict[str, tuple[int, int]], defines: dict[str, int]) -> str:
    output: list[str] = []
    current_global: str | None = None
    event_byte: int | str | None = None
    skip_debug = False
    in_macro = False
    for path, raw in expanded_lines(paths):
            code, separator, comment = raw.partition(';')
            stripped = code.strip()
            if not stripped:
                output.append(raw)
                continue
            if stripped.upper() == 'IF DEF(_DEBUG)':
                skip_debug = True
                continue
            if skip_debug:
                if stripped.upper() == 'ENDC':
                    skip_debug = False
                continue
            if re.match(r'^MACRO\s+', stripped, re.IGNORECASE):
                in_macro = True
                continue
            if in_macro:
                if stripped.upper() == 'ENDM':
                    in_macro = False
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
                    tx_pre = re.match(r'^(tx_pre|tx_pre_jump|tx_pre_id)\s+([A-Za-z_][A-Za-z0-9_]*)$', stripped)
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
                    elif tx_pre:
                        kind, target = tx_pre.groups()
                        _, base = symbols['TextPredefs']
                        _, entry = symbols[target + '_id']
                        text_id = (entry - base) // 2 + 1
                        if kind == 'tx_pre_id':
                            converted = f'\tld a, ${text_id:02x}'
                        else:
                            jump = 'jp' if kind == 'tx_pre_jump' else 'call'
                            converted = f'\tld a, ${text_id:02x}\n\t{jump} PrintPredefTextID'
                    elif text_far:
                        target = text_far.group(1)
                        bank, address = symbols[target]
                        converted = f'\t.DB $17\n\t.DW ${address:04x}\n\t.DB ${bank:02x}'
                    elif stripped == 'text_asm':
                        converted = '\t.DB $08'
                    elif stripped == 'text_promptbutton':
                        converted = '\t.DB $06'
                    elif stripped == 'text_pause':
                        converted = '\t.DB $0a'
                    elif stripped == 'text_end':
                        converted = '\t.DB $50'
                    elif stripped in {'sound_get_item_1', 'sound_level_up'}:
                        converted = '\t.DB $0b'
                    elif stripped == 'sound_get_item_2':
                        converted = '\t.DB $10'
                    elif stripped == 'text_waitbutton':
                        converted = '\t.DB $0d'
                    elif stripped == 'script_players_pc':
                        converted = '\t.DB $fc'
                    elif re.match(r'^db\s+', stripped, re.IGNORECASE):
                        value = qualify(re.sub(r'^db\s+', '', stripped, flags=re.IGNORECASE), current_global)
                        if value.startswith('"') and value.endswith('"') and ',' not in value:
                            converted = f'\t.STRINGMAP pokemon, {value}'
                        else:
                            converted = f'\t.DB {value}'
                    elif re.match(r'^dw\s+', stripped, re.IGNORECASE):
                        value = qualify(re.sub(r'^dw\s+', '', stripped, flags=re.IGNORECASE), current_global)
                        converted = f'\t.DW {value}'
                    elif re.match(r'^dbw\s+', stripped, re.IGNORECASE):
                        values = operands(re.sub(r'^dbw\s+', '', stripped, flags=re.IGNORECASE))
                        converted = f'\t.DB {values[0]}\n\t.DW {qualify(values[1], current_global)}'
                    elif re.match(r'^next\s+', stripped, re.IGNORECASE):
                        value = re.sub(r'^next\s+', '', stripped, flags=re.IGNORECASE)
                        converted = f'\t.DB $4e\n\t.STRINGMAP pokemon, {value}'
                    elif re.match(r'^door_tiles\b', stripped, re.IGNORECASE):
                        value = re.sub(r'^door_tiles\s*', '', stripped, flags=re.IGNORECASE)
                        converted = (f'\t.DB {value}, 0' if value else '\t.DB 0')
                    elif re.match(r'^hidden_(?:item|coin)\s+', stripped, re.IGNORECASE):
                        values = operands(stripped.split(None, 1)[1])
                        converted = f'\t.DB {values[0]}, {values[2]}, {values[1]}'
                    elif re.match(r'^growth_rate\s+', stripped, re.IGNORECASE):
                        values = operands(re.sub(r'^growth_rate\s+', '', stripped, flags=re.IGNORECASE))
                        signed = int(values[2], 0)
                        converted = f'\t.DB ({values[0]} << 4) | {values[1]}, {abs(signed)}' + (' | $80' if signed < 0 else '') + f', {values[3]}, {values[4]}'
                    elif re.match(r'^(?:table_width|assert_(?:max_)?table_length)\b', stripped, re.IGNORECASE):
                        converted = '; ' + stripped
                    elif re.match(r'^gym_gate_coord\s+', stripped, re.IGNORECASE):
                        value = re.sub(r'^gym_gate_coord\s+', '', stripped, flags=re.IGNORECASE)
                        converted = f'\t.DB {value}, 0'
                    elif re.match(r'^hlcoord\s+', stripped, re.IGNORECASE):
                        values = operands(re.sub(r'^hlcoord\s+', '', stripped, flags=re.IGNORECASE))
                        origin = values[2] if len(values) > 2 else 'wTileMap'
                        converted = f'\tld hl, {origin} + ({values[1]} * 20) + {values[0]}'
                    elif re.match(r'^lda_coord\s+', stripped, re.IGNORECASE):
                        values = operands(re.sub(r'^lda_coord\s+', '', stripped, flags=re.IGNORECASE))
                        origin = values[2] if len(values) > 2 else 'wTileMap'
                        converted = f'\tld a, ({origin} + ({values[1]} * 20) + {values[0]})'
                    elif re.match(r'^lb\s+', stripped, re.IGNORECASE):
                        values = operands(re.sub(r'^lb\s+', '', stripped, flags=re.IGNORECASE))
                        for target, (bank, _) in symbols.items():
                            values[1] = values[1].replace(f'BANK({target})', f'${bank:02x}')
                            values[2] = values[2].replace(f'BANK({target})', f'${bank:02x}')
                        converted = f'\tld {values[0]}, (({values[1]}) << 8) | ({values[2]})'
                    elif re.match(r'^CheckEventHL\s+', stripped):
                        event = stripped.split(None, 1)[1]
                        event_byte = defines[event] // 8 if event in defines else event
                        converted = f'\tld hl, wEventFlags + ({event} / 8)\n\tbit {event} & 7, (hl)'
                    elif re.match(r'^CheckEvent\s+', stripped):
                        event = operands(stripped.split(None, 1)[1])[0]
                        event_byte = defines[event] // 8 if event in defines else event
                        converted = f'\tld a, (wEventFlags + ({event} / 8))\n\tbit {event} & 7, a'
                    elif re.match(r'^CheckEventReuseA\s+', stripped):
                        event = stripped.split(None, 1)[1]
                        next_event_byte = defines[event] // 8 if event in defines else event
                        load = '' if next_event_byte == event_byte else f'\tld a, (wEventFlags + ({event} / 8))\n'
                        event_byte = next_event_byte
                        converted = load + f'\tbit {event} & 7, a'
                    elif re.match(r'^EventFlagAddress\s+', stripped):
                        values = operands(stripped.split(None, 1)[1])
                        event_byte = values[1]
                        converted = f'\tld {values[0]}, wEventFlags + ({values[1]} / 8)'
                    elif re.match(r'^(SetEvent|ResetEvent)\s+', stripped):
                        kind, event = stripped.split(None, 1)
                        operation = 'set' if kind == 'SetEvent' else 'res'
                        converted = f'\tld hl, wEventFlags + ({event} / 8)\n\t{operation} {event} & 7, (hl)'
                    elif re.match(r'^AdjustEventBit\s+', stripped):
                        values = operands(stripped.split(None, 1)[1])
                        if values[0] in defines and (defines[values[0]] & 7) == int(values[1], 0):
                            converted = f'; {stripped} (no adjustment)'
                        else:
                            converted = f'\tadd ({values[0]} & 7) - ({values[1]})'
                    elif re.match(r'^INCBIN\s+', stripped, re.IGNORECASE):
                        converted = '\t.' + stripped
                    elif re.match(r'^DEF\s+', stripped, re.IGNORECASE):
                        match = re.match(r'^DEF\s+(\w+)\s+EQU\s+(.+)$', stripped, re.IGNORECASE)
                        if not match:
                            raise ValueError(f'{path}: unsupported definition: {stripped}')
                        converted = f'.DEFINE {match.group(1)} {match.group(2)}'
                    elif UNSUPPORTED_RE.match(stripped):
                        raise ValueError(f'{path}: unsupported construct: {stripped}')
                    elif current_global is None:
                        raise ValueError(f'{path}: instruction before global label: {stripped}')
                    else:
                        converted = qualify(stripped, current_global)
                        for target, (bank, _) in symbols.items():
                            converted = converted.replace(f'BANK({target})', f'${bank:02x}')
                        converted = re.sub(r'vChars1\s+tile\s+([^,]+)', r'vChars1 + (\1) * 16', converted)
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
    parser.add_argument('--defines', type=Path)
    parser.add_argument('sources', nargs='+', type=Path)
    args = parser.parse_args()
    print(convert(args.sources, load_symbols(args.symbols), load_defines(args.defines)), end='')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
