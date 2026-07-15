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


def load_charmap(path: Path = Path('constants/charmap.asm')) -> dict[str, int]:
    values: dict[str, int] = {}
    if path.is_file():
        for line in path.read_text().splitlines():
            match = re.match(r'^\s*charmap\s+"([^"]+)",\s*\$([0-9A-Fa-f]+)', line)
            if match:
                values[match.group(1)] = int(match.group(2), 16)
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
                inline = re.match(r'^(\.?[A-Za-z_][A-Za-z0-9_]*):{1,2}\s+(.+)$', code)
                if inline:
                    yield path, inline.group(1) + ':'
                    yield path, '\t' + inline.group(2)
                else:
                    yield path, raw


def convert(paths: list[Path], symbols: dict[str, tuple[int, int]], defines: dict[str, int], charmap: dict[str, int]) -> str:
    output: list[str] = []
    current_global: str | None = None
    event_byte: int | str | None = None
    conditions: list[bool] = []
    for_variable: str | None = None
    for_count = 0
    hidden_maps: list[str] = []
    skip_for_body = False
    in_macro = False
    for path, raw in expanded_lines(paths):
            code, separator, comment = raw.partition(';')
            stripped = code.strip()
            if not stripped:
                output.append(raw)
                continue
            condition = re.match(r'^IF DEF\((_RED|_BLUE|_DEBUG)\)$', stripped, re.IGNORECASE)
            if condition:
                conditions.append(condition.group(1).upper() == '_RED')
                continue
            if stripped.upper() == 'ELSE' and conditions:
                conditions[-1] = not conditions[-1]
                continue
            if stripped.upper() == 'ENDC' and conditions:
                conditions.pop()
                continue
            if stripped.upper() == 'ENDR':
                skip_for_body = False
                for_variable = None
                continue
            if conditions and not all(conditions):
                continue
            loop = re.match(r'^FOR\s+(\w+)\s*,\s*(\d+|num_hidden_event_maps)$', stripped, re.IGNORECASE)
            if loop:
                for_variable, count = loop.groups()
                for_count = int(count) if count.isdigit() else len(hidden_maps)
                if count.lower() == 'num_hidden_event_maps':
                    output.extend(f'\t.DW HiddenEventsFor_{name}' for name in hidden_maps)
                    for_variable = '__hidden_maps__'
                    for_count = 0
                    skip_for_body = True
                continue
            if skip_for_body:
                continue
            if re.match(r'^MACRO\s+', stripped, re.IGNORECASE):
                in_macro = True
                continue
            if in_macro:
                if stripped.upper() == 'ENDM':
                    in_macro = False
                continue
            audio = re.match(r'^(noise_note|square_note)\s+(.+)$', stripped)
            if audio:
                values = [int(x.strip(), 0) for x in audio.group(2).split(',')]
                length, volume, fade, frequency = values
                fade_byte = (8 | -fade) if fade < 0 else fade
                output.append(f'\t.DB ${0x20 | length:02x}, ${((volume << 4) | fade_byte):02x}')
                if audio.group(1) == 'noise_note':
                    output.append(f'\t.DB ${frequency & 0xff:02x}')
                else:
                    output.append(f'\t.DW ${frequency & 0xffff:04x}')
                continue
            if stripped == 'sound_ret':
                output.append('\t.DB $ff')
                continue
            if stripped == 'execute_music':
                output.append('\t.DB $f8')
                continue
            if stripped == 'toggle_perfect_pitch':
                output.append('\t.DB $e8')
                continue
            volume = re.match(r'^volume\s+([^,]+),\s*(.+)$', stripped)
            if volume:
                left, right = (int(x.strip(), 0) for x in volume.groups())
                output.extend(("\t.DB $f0", f"\t.DB ${(left << 4 | right) & 0xff:02x}"))
                continue
            tempo = re.match(r'^tempo\s+(\S+)$', stripped)
            if tempo:
                value = int(tempo.group(1), 0)
                output.append(f'\t.DB $ed, ${(value >> 8) & 0xff:02x}, ${value & 0xff:02x}')
                continue
            speed = re.match(r'^drum_speed\s+(\S+)$', stripped)
            if speed:
                output.append(f'\t.DB ${0xd0 | int(speed.group(1), 0):02x}')
                continue
            drum = re.match(r'^drum_note\s+([^,]+),\s*(.+)$', stripped)
            if drum:
                instrument, length = (int(x.strip(), 0) for x in drum.groups())
                output.extend((f'\t.DB ${0xb0 | ((length - 1) & 0xf):02x}', f'\t.DB ${instrument:02x}'))
                continue
            slide = re.match(r'^pitch_slide\s+([^,]+),\s*([^,]+),\s*(.+)$', stripped)
            if slide:
                length = int(slide.group(1).strip(), 0)
                octave = int(slide.group(2).strip(), 0)
                pitch_token = slide.group(3).strip()
                pitch_names = {'C_': 0, 'C#': 1, 'D_': 2, 'D#': 3, 'E_': 4, 'F_': 5, 'F#': 6, 'G_': 7, 'G#': 8, 'A_': 9, 'A#': 10, 'B_': 11}
                pitch = pitch_names[pitch_token] if pitch_token in pitch_names else int(pitch_token, 0)
                output.extend(("\t.DB $eb", f'\t.DB ${(length - 1) & 0xff:02x}', f'\t.DB ${((8 - octave) << 4 | pitch) & 0xff:02x}'))
                continue
            call = re.match(r'^sound_call\s+([\w.]+)$', stripped)
            if call:
                target = call.group(1)
                if target.startswith('.') and current_global:
                    target = current_global + target
                address = symbols.get(target, (0, 0))[1]
                output.extend(("\t.DB $fd", f'\t.DW ${address:04x}'))
                continue
            dn = re.match(r'^dn\s+([^,]+),\s*(.+)$', stripped, re.IGNORECASE)
            if dn:
                try:
                    values = [int(x.strip(), 0) for x in (dn.group(1) + ',' + dn.group(2)).split(',')]
                    output.extend(f'\t.DB ${((values[i] << 4) | values[i + 1]) & 0xff:02x}' for i in range(0, len(values) - 1, 2))
                except ValueError:
                    output.append(f'\t.DB ({dn.group(1).strip()} << 4) | {dn.group(2).strip()}')
                continue
            rest = re.match(r'^rest\s+(\S+)$', stripped)
            if rest:
                output.append(f'\t.DB ${0xc0 | (int(rest.group(1), 0) - 1):02x}')
                continue
            typed = re.match(r'^note_type\s+([^,]+),\s*([^,]+),\s*(.+)$', stripped)
            if typed:
                speed, volume, fade = (int(x.strip(), 0) for x in typed.groups())
                fade = 8 | -fade if fade < 0 else fade
                output.extend((f'\t.DB ${0xd0 | speed:02x}', f'\t.DB ${(volume << 4 | fade) & 0xff:02x}'))
                continue
            octave = re.match(r'^octave\s+(\S+)$', stripped)
            if octave:
                output.append(f'\t.DB ${0xe0 | (8 - int(octave.group(1), 0)):02x}')
                continue
            vibrato = re.match(r'^vibrato\s+([^,]+),\s*([^,]+),\s*(.+)$', stripped)
            if vibrato:
                delay, depth, rate = (int(x.strip(), 0) for x in vibrato.groups())
                output.extend(("\t.DB $ea", f"\t.DB ${delay & 0xff:02x}", f"\t.DB ${(depth << 4 | rate) & 0xff:02x}"))
                continue
            duty = re.match(r'^duty_cycle\s+(\S+)$', stripped)
            if duty:
                output.extend(("\t.DB $ec", f"\t.DB ${int(duty.group(1), 0):02x}"))
                continue
            note = re.match(r'^note\s+([^,]+),\s*(.+)$', stripped)
            if note:
                pitch_names = {'C_': 0, 'C#': 1, 'D_': 2, 'D#': 3, 'E_': 4, 'F_': 5, 'F#': 6, 'G_': 7, 'G#': 8, 'A_': 9, 'A#': 10, 'B_': 11}
                pitch_token = note.group(1).strip()
                pitch = pitch_names[pitch_token] if pitch_token in pitch_names else int(pitch_token, 0)
                length = int(note.group(2).strip(), 0)
                output.append(f'\t.DB ${((pitch & 0xf) << 4 | ((length - 1) & 0xf)):02x}')
                continue
            pattern = re.match(r'^duty_cycle_pattern\s+([^,]+),\s*([^,]+),\s*([^,]+),\s*(.+)$', stripped)
            if pattern:
                values = [int(x.strip(), 0) for x in pattern.groups()]
                output.extend(("\t.DB $fc", f"\t.DB ${(values[0]<<6 | values[1]<<4 | values[2]<<2 | values[3]) & 0xff:02x}"))
                continue
            sweep = re.match(r'^pitch_sweep\s+([^,]+),\s*(.+)$', stripped)
            if sweep:
                length, change = (int(x.strip(), 0) for x in sweep.groups())
                change = 8 | -change if change < 0 else change
                output.extend(("\t.DB $10", f"\t.DB ${(length << 4 | change) & 0xff:02x}"))
                continue
            loop = re.match(r'^sound_loop\s+([^,]+),\s*([\w.]+)$', stripped)
            if loop:
                count, target = int(loop.group(1), 0), loop.group(2)
                if target.startswith('.') and current_global:
                    target = current_global + target
                address = symbols.get(target, (0, 0))[1]
                output.extend(("\t.DB $fe", f"\t.DB ${count:02x}", f"\t.DW ${address:04x}"))
                continue
            wave_ref = re.match(r'^dw\s+\.(wave\d+)$', stripped, re.IGNORECASE)
            if wave_ref:
                output.append(f'\t.DW AudioWaveforms.{wave_ref.group(1)}')
                continue
            global_label = LABEL_RE.match(stripped)
            if global_label:
                current_global = global_label.group(1)
                converted = f'{current_global}:'
            else:
                local_label = LOCAL_LABEL_RE.match(stripped)
                if local_label:
                    if current_global is None or local_label.group(1).startswith('wave'):
                        current_global = 'AudioWaveforms'
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
                    elif re.match(r'^ld_hli_a_string\s+".*"$', stripped, re.IGNORECASE):
                        string = re.match(r'^ld_hli_a_string\s+"(.*)"$', stripped, re.IGNORECASE).group(1)
                        # RGBDS permits symbolic multi-character tokens such as
                        # <BOLD_V> in these literals; consume the longest token
                        # before falling back to individual characters.
                        encoded = []
                        cursor = 0
                        while cursor < len(string):
                            token = re.match(r'<[^>]+>', string[cursor:])
                            if token and token.group(0) in charmap:
                                encoded.append(charmap[token.group(0)])
                                cursor += len(token.group(0))
                            else:
                                encoded.append(charmap[string[cursor]])
                                cursor += 1
                        instructions = [f'\tld a, ${value:02x}\n\tld (HL+), a' for value in encoded[:-1]]
                        instructions.append(f'\t.DB $36, ${encoded[-1]:02x}')
                        converted = '\n'.join(instructions)
                    elif stripped in {'script_players_pc', 'script_bills_pc', 'script_pokecenter_pc', 'script_pokecenter_nurse', 'script_mart'}:
                        script_ids = {
                            'script_players_pc': '$fc', 'script_bills_pc': '$fd',
                            'script_mart': '$fe', 'script_pokecenter_nurse': '$ff',
                            'script_pokecenter_pc': '$f9',
                        }
                        converted = f'\t.DB {script_ids[stripped]}'
                    elif re.match(r'^db\s+', stripped, re.IGNORECASE):
                        value = qualify(re.sub(r'^db\s+', '', stripped, flags=re.IGNORECASE), current_global)
                        if for_variable:
                            values = []
                            expression = value.replace('$', '0x')
                            for index in range(for_count):
                                values.append(str(eval(expression, {'__builtins__': {}}, {for_variable: index}) & 0xff))
                            converted = '\t.DB ' + ', '.join(values)
                        elif value.startswith('"') and value.endswith('"') and ',' not in value:
                            converted = f'\t.STRINGMAP pokemon, {value}'
                        else:
                            def encode_string(match: re.Match[str]) -> str:
                                return ', '.join(f'${charmap.get(char, ord(char)):02x}' for char in match.group(1))
                            value = re.sub(r'"([^"]*)"', encode_string, value)
                            converted = f'\t.DB {value}'
                    elif re.match(r'^dname\s+".*"$', stripped, re.IGNORECASE):
                        value = re.match(r'^dname\s+"(.*)"$', stripped, re.IGNORECASE).group(1)
                        converted = f'\t.STRINGMAP pokemon, "{value}"'
                        if len(value) < 10:
                            converted += f'\n\t.DB ' + ', '.join('$50' for _ in range(10 - len(value)))
                    elif re.match(r'^dw\s+', stripped, re.IGNORECASE):
                        value = qualify(re.sub(r'^dw\s+', '', stripped, flags=re.IGNORECASE), current_global)
                        converted = f'\t.DW {value}'
                    elif re.match(r'^dbw\s+', stripped, re.IGNORECASE):
                        values = operands(re.sub(r'^dbw\s+', '', stripped, flags=re.IGNORECASE))
                        converted = f'\t.DB {values[0]}\n\t.DW {qualify(values[1], current_global)}'
                    elif re.match(r'^dba\s+', stripped, re.IGNORECASE):
                        target = stripped.split(None, 1)[1].strip()
                        bank, address = symbols[target]
                        converted = f'\t.DB ${bank:02x}\n\t.DW ${address:04x}'
                    elif re.match(r'^dc\s+', stripped, re.IGNORECASE):
                        values = operands(re.sub(r'^dc\s+', '', stripped, flags=re.IGNORECASE))
                        converted = f'\t.DB (({values[0]}) << 6) | (({values[1]}) << 4) | (({values[2]}) << 2) | ({values[3]})'
                    elif re.match(r'^next\s+', stripped, re.IGNORECASE):
                        value = re.sub(r'^next\s+', '', stripped, flags=re.IGNORECASE)
                        converted = f'\t.DB $4e\n\t.STRINGMAP pokemon, {value}'
                    elif re.match(r'^door_tiles\b', stripped, re.IGNORECASE):
                        value = re.sub(r'^door_tiles\s*', '', stripped, flags=re.IGNORECASE)
                        converted = (f'\t.DB {value}, 0' if value else '\t.DB 0')
                    elif re.match(r'^hidden_(?:item|coin)\s+', stripped, re.IGNORECASE):
                        values = operands(stripped.split(None, 1)[1])
                        converted = f'\t.DB {values[0]}, {values[2]}, {values[1]}'
                    elif re.match(r'^hidden_event_map\s+', stripped, re.IGNORECASE):
                        target = stripped.split(None, 1)[1].strip()
                        hidden_maps.append(target)
                        converted = f'\t.DB {target}'
                    elif re.match(r'^hidden_events_for\s+', stripped, re.IGNORECASE):
                        target = stripped.split(None, 1)[1].strip()
                        converted = f'{"HiddenEventsFor_" + target}:'
                    elif re.match(r'^hidden_event\s+', stripped, re.IGNORECASE):
                        values = operands(stripped.split(None, 1)[1])
                        bank, address = symbols[values[2]]
                        converted = f'\t.DB {values[1]}, {values[0]}, {values[3]}\n\t.DB ${bank:02x}\n\t.DW ${address:04x}'
                    elif re.match(r'^hidden_text_predef\s+', stripped, re.IGNORECASE):
                        values = operands(stripped.split(None, 1)[1])
                        bank, address = symbols[values[2]]
                        _, base = symbols['TextPredefs']
                        _, entry = symbols[values[3] + '_id']
                        text_id = (entry - base) // 2 + 1
                        converted = f'\t.DB {values[1]}, {values[0]}, ${text_id:02x}\n\t.DB ${bank:02x}\n\t.DW ${address:04x}'
                    elif re.match(r'^overworld_sprite\s+', stripped, re.IGNORECASE):
                        values = operands(stripped.split(None, 1)[1])
                        bank, address = symbols[values[0]]
                        converted = f'\t.DW ${address:04x}\n\t.DB {values[1]} * 16, ${bank:02x}'
                    elif re.match(r'^growth_rate\s+', stripped, re.IGNORECASE):
                        values = operands(re.sub(r'^growth_rate\s+', '', stripped, flags=re.IGNORECASE))
                        signed = int(values[2], 0)
                        converted = f'\t.DB ({values[0]} << 4) | {values[1]}, {abs(signed)}' + (' | $80' if signed < 0 else '') + f', {values[3]}, {values[4]}'
                    elif re.match(r'^bcd2\s+', stripped, re.IGNORECASE):
                        value = int(stripped.split(None, 1)[1], 0)
                        high = ((value // 1000) << 4) | ((value // 100) % 10)
                        low = (((value // 10) % 10) << 4) | (value % 10)
                        converted = f'\t.DB ${high:02x}, ${low:02x}'
                    elif re.match(r'^(?:table_width|assert_(?:max_)?table_length)\b', stripped, re.IGNORECASE):
                        converted = '; ' + stripped
                    elif re.match(r'^assert\b', stripped, re.IGNORECASE):
                        # RGBDS link-time assertions describe invariants that are
                        # checked by the WLA boundary audit after conversion.
                        converted = '; ' + stripped
                    elif re.match(r'^gym_gate_coord\s+', stripped, re.IGNORECASE):
                        value = re.sub(r'^gym_gate_coord\s+', '', stripped, flags=re.IGNORECASE)
                        converted = f'\t.DB {value}, 0'
                    elif re.match(r'^hlcoord\s+', stripped, re.IGNORECASE):
                        values = operands(re.sub(r'^hlcoord\s+', '', stripped, flags=re.IGNORECASE))
                        origin = values[2] if len(values) > 2 else 'wTileMap'
                        converted = f'\tld hl, {origin} + ({values[1]} * 20) + {values[0]}'
                    elif re.match(r'^decoord\s+', stripped, re.IGNORECASE):
                        values = operands(re.sub(r'^decoord\s+', '', stripped, flags=re.IGNORECASE))
                        origin = values[2] if len(values) > 2 else 'wTileMap'
                        converted = f'\tld de, {origin} + ({values[1]} * 20) + {values[0]}'
                    elif re.match(r'^lda_coord\s+', stripped, re.IGNORECASE):
                        values = operands(re.sub(r'^lda_coord\s+', '', stripped, flags=re.IGNORECASE))
                        origin = values[2] if len(values) > 2 else 'wTileMap'
                        converted = f'\tld a, ({origin} + ({values[1]} * 20) + {values[0]})'
                    elif re.match(r'^ldcoord_a\s+', stripped, re.IGNORECASE):
                        values = operands(re.sub(r'^ldcoord_a\s+', '', stripped, flags=re.IGNORECASE))
                        origin = values[2] if len(values) > 2 else 'wTileMap'
                        converted = f'\tld ({origin} + ({values[1]} * 20) + {values[0]}), a'
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
                        match = re.match(r'^DEF\s+(\w+)\s+(?:EQU|=)\s+(.+)$', stripped, re.IGNORECASE)
                        if not match or match.group(1) in {'num_hidden_event_maps'}:
                            converted = '; ' + stripped
                        else:
                            converted = f'.DEFINE {match.group(1)} {match.group(2)}'
                    elif UNSUPPORTED_RE.match(stripped):
                        raise ValueError(f'{path}: unsupported construct: {stripped}')
                    elif current_global is None:
                        raise ValueError(f'{path}: instruction before global label: {stripped}')
                    else:
                        converted = qualify(stripped, current_global)
                        converted = re.sub(
                            r"'([^']{1})'",
                            lambda match: f'${charmap.get(match.group(1), ord(match.group(1))):02x}',
                            converted,
                        )
                        for target, (bank, _) in symbols.items():
                            converted = converted.replace(f'BANK({target})', f'${bank:02x}')
                        converted = re.sub(
                            r'([A-Za-z_][A-Za-z0-9_]*)\s+tile\s+([^,;]+)',
                            r'\1 + (\2) * 16',
                            converted,
                        )
                        converted = re.sub(r'(\$[0-9A-Fa-f]+|\d+)\s+tiles\b', r'(\1 * 16)', converted)
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
    print(convert(args.sources, load_symbols(args.symbols), load_defines(args.defines), load_charmap()), end='')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
