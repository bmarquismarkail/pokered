#!/usr/bin/env python3
"""Structural split coverage checks against the fixed WLA-DX monolith."""

from __future__ import annotations

import argparse
import re
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from reconcile_audit import audit_reconcile_tree, print_reconcile_audit

BANK_RE = re.compile(r'^\.BANK\s+(\d+)(?:\s+SLOT\s+\d+)?')
LABEL_RE = re.compile(r'^[A-Za-z_][A-Za-z0-9_]*:{1,2}\s*($|;|\.)')
INCLUDE_BANK_RE = re.compile(r'^\.INCLUDE\s+"wla/pkrd/bank(\d{2})\.asm"', re.MULTILINE)
INCLUDE_RE = re.compile(r'^\.INCLUDE\s+"([^"]+)"', re.MULTILINE)


def labels_by_bank(path: Path) -> dict[int, list[str]]:
    result: dict[int, list[str]] = {}
    current_bank: int | None = None
    for raw in path.read_text(errors='replace').splitlines():
        line = raw.rstrip()
        bank = BANK_RE.match(line)
        if bank:
            current_bank = int(bank.group(1))
            result.setdefault(current_bank, [])
            continue
        if current_bank is None:
            continue
        if LABEL_RE.match(line):
            result[current_bank].append(line.split(':', 1)[0].strip())
    return result


def file_labels(path: Path) -> list[str]:
    labels: list[str] = []
    for raw in path.read_text(errors='replace').splitlines():
        line = raw.rstrip()
        if LABEL_RE.match(line):
            labels.append(line.split(':', 1)[0].strip())
    return labels


def file_labels_with_includes(path: Path) -> list[str]:
    labels = file_labels(path)
    source = path.read_text(errors='replace')
    for include in INCLUDE_RE.findall(source):
        include_path = Path(include)
        if include_path.is_file():
            labels.extend(file_labels(include_path))
    return labels


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('monolith', type=Path)
    ap.add_argument('--split-dir', type=Path, default=Path('wla/pkrd'))
    args = ap.parse_args()

    split_dir = args.split_dir
    prelude = split_dir / 'prelude.asm'
    main = split_dir / 'main.asm'
    banks = [split_dir / f'bank{i:02d}.asm' for i in range(64)]

    missing = [path for path in [prelude, main, *banks] if not path.is_file()]
    if missing:
        print(f'FAIL missing split files: {len(missing)}')
        for path in missing[:20]:
            print(f'  {path}')
        return 1
    print('OK split files present: prelude + 64 banks + main')

    for i, path in enumerate(banks):
        text = path.read_text(errors='replace')
        if not re.search(rf'^\.BANK\s+{i}(?:\s|$)', text, re.MULTILINE):
            print(f'FAIL {path} missing .BANK {i} marker')
            return 1
    print('OK split bank files contain expected .BANK markers: 64/64')

    main_text = main.read_text(errors='replace')
    if main_text.count('.INCLUDE "wla/pkrd/prelude.asm"') != 1:
        print('FAIL main.asm missing single prelude include')
        return 1
    bank_includes = sorted(int(m.group(1)) for m in INCLUDE_BANK_RE.finditer(main_text))
    if bank_includes != list(range(64)):
        print(f'FAIL main.asm bank include set is incomplete: {bank_includes[:8]} ... {bank_includes[-8:]}')
        return 1
    if 'data/pkrd/' in '\n'.join(line for line in main_text.splitlines() if line.lstrip().startswith('.INCLUDE')):
        print('FAIL main.asm include paths still reference root data/pkrd')
        return 1
    print('OK main.asm references prelude and 64 banks')

    bank42_text = Path('wla/banks/bank42_text.asm')
    bank42_source = banks[42].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank42_text.asm"' not in bank42_source:
        print('FAIL bank42 is not using its structured Text 11 include')
        return 1
    if not bank42_text.is_file():
        print(f'FAIL structured bank42 include missing: {bank42_text}')
        return 1
    bank42_labels = file_labels(bank42_text)
    if len(bank42_labels) != 30 or bank42_labels[0] != '_ItemUseText001' or bank42_labels[-1] != 'Bank42TextEnd':
        print(f'FAIL structured bank42 label boundary changed: {len(bank42_labels)} labels')
        return 1
    bank42_text_source = bank42_text.read_text(errors='replace')
    if '.STRINGMAP pokemon,' not in bank42_text_source or '.STRINGMAPTABLE pokemon "wla/pokemon.tbl"' not in bank42_text_source:
        print('FAIL bank42 Text 11 is not using the Pokemon WLA string map')
        return 1

    charmap_source = Path('constants/charmap.asm').read_text(errors='replace').splitlines()
    expected_map: list[str] = []
    for raw in charmap_source:
        match = re.search(r'charmap\s+"([^"]*)",\s*\$([0-9a-fA-F]{2})', raw)
        if match:
            expected_map.append(f'{match.group(2).lower()}={match.group(1)}')
    table_lines = [line for line in Path('wla/pokemon.tbl').read_text(errors='replace').splitlines() if line and not line.startswith(';')]
    if table_lines != expected_map:
        print('FAIL wla/pokemon.tbl is out of sync with constants/charmap.asm')
        return 1
    if '.DSB $4000 - $0330, $00' not in bank42_source or 'Bank42End::' not in bank42_source:
        print('FAIL bank42 is missing its end-label-derived linked-size assertion')
        return 1
    print(f'OK bank42 uses structured Text 11 include: 29 records, end/size assertions, {len(table_lines)} charmap entries')

    bank32_text = Path('wla/banks/bank32_text.asm')
    bank32_source = banks[32].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank32_text.asm"' not in bank32_source:
        print('FAIL bank32 is not using its structured Text 1 include')
        return 1
    bank32_labels = file_labels(bank32_text)
    if len(bank32_labels) != 266 or bank32_labels[0] != '_CardKeySuccessText1' or bank32_labels[-1] != 'Bank32TextEnd':
        print(f'FAIL structured bank32 label boundary changed: {len(bank32_labels)} labels')
        return 1
    if '.DSB $4000 - $2aaf, $00' not in bank32_source or 'Bank32End::' not in bank32_source:
        print('FAIL bank32 is missing its end-label and linked-size assertion')
        return 1
    print('OK bank32 uses structured Text 1 include: 265 records, end/size assertions')

    bank33_text = Path('wla/banks/bank33_text.asm')
    bank33_source = banks[33].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank33_text.asm"' not in bank33_source:
        print('FAIL bank33 is not using its structured Text 2 include')
        return 1
    bank33_labels = file_labels(bank33_text)
    if len(bank33_labels) != 203 or bank33_labels[0] != '_SilphCo5FRockerEndBattleText' or bank33_labels[-1] != 'Bank33TextEnd':
        print(f'FAIL structured bank33 label boundary changed: {len(bank33_labels)} labels')
        return 1
    if '.DSB $4000 - $2ca1, $00' not in bank33_source or 'Bank33End::' not in bank33_source:
        print('FAIL bank33 is missing its end-label and linked-size assertion')
        return 1
    print('OK bank33 uses structured Text 2 include: 202 records, end/size assertions')

    bank34_text = Path('wla/banks/bank34_text.asm')
    bank34_source = banks[34].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank34_text.asm"' not in bank34_source:
        print('FAIL bank34 is not using its structured Text 3 include')
        return 1
    bank34_labels = file_labels(bank34_text)
    if len(bank34_labels) != 316 or bank34_labels[0] != '_RockTunnelB1FHiker3AfterBattleText' or bank34_labels[-1] != 'Bank34TextEnd':
        print(f'FAIL structured bank34 label boundary changed: {len(bank34_labels)} labels')
        return 1
    if '.DSB $4000 - $2cf9, $00' not in bank34_source or 'Bank34End::' not in bank34_source:
        print('FAIL bank34 is missing its end-label and linked-size assertion')
        return 1
    print('OK bank34 uses structured Text 3 include: 315 records, end/size assertions')

    bank35_text = Path('wla/banks/bank35_text.asm')
    bank35_source = banks[35].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank35_text.asm"' not in bank35_source:
        print('FAIL bank35 is not using its structured Text 4 include')
        return 1
    bank35_labels = file_labels(bank35_text)
    if len(bank35_labels) != 269 or bank35_labels[0] != '_DaycareGentlemanAllRightThenText' or bank35_labels[-1] != 'Bank35TextEnd':
        print(f'FAIL structured bank35 label boundary changed: {len(bank35_labels)} labels')
        return 1
    if '.DSB $4000 - $2c09, $00' not in bank35_source or 'Bank35End::' not in bank35_source:
        print('FAIL bank35 is missing its end-label and linked-size assertion')
        return 1
    print('OK bank35 uses structured Text 4 include: 268 records, end/size assertions')

    bank36_text = Path('wla/banks/bank36_text.asm')
    bank36_source = banks[36].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank36_text.asm"' not in bank36_source:
        print('FAIL bank36 is not using its structured Text 5 include')
        return 1
    bank36_labels = file_labels(bank36_text)
    if len(bank36_labels) != 308 or bank36_labels[0] != '_Route11SuperNerd2EndBattleText' or bank36_labels[-1] != 'Bank36TextEnd':
        print(f'FAIL structured bank36 label boundary changed: {len(bank36_labels)} labels')
        return 1
    if '.DSB $4000 - $2903, $00' not in bank36_source or 'Bank36End::' not in bank36_source:
        print('FAIL bank36 is missing its end-label and linked-size assertion')
        return 1
    print('OK bank36 uses structured Text 5 include: 307 records, end/size assertions')

    bank37_text = Path('wla/banks/bank37_text.asm')
    bank37_source = banks[37].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank37_text.asm"' not in bank37_source:
        print('FAIL bank37 is not using its structured Text 6 include')
        return 1
    bank37_labels = file_labels(bank37_text)
    if len(bank37_labels) != 250 or bank37_labels[0] != '_Route24CooltrainerM2EndBattleText' or bank37_labels[-1] != 'Bank37TextEnd':
        print(f'FAIL structured bank37 label boundary changed: {len(bank37_labels)} labels')
        return 1
    if '.DSB $4000 - $2a38, $00' not in bank37_source or 'Bank37End::' not in bank37_source:
        print('FAIL bank37 is missing its end-label and linked-size assertion')
        return 1
    print('OK bank37 uses structured Text 6 include: 249 records, end/size assertions')

    bank38_text = Path('wla/banks/bank38_text.asm')
    bank38_source = banks[38].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank38_text.asm"' not in bank38_source:
        print('FAIL bank38 is not using its structured Text 7 include')
        return 1
    bank38_labels = file_labels(bank38_text)
    if len(bank38_labels) != 182 or bank38_labels[0] != '_PewterGymBrockPostBattleAdviceText' or bank38_labels[-1] != 'Bank38TextEnd':
        print(f'FAIL structured bank38 label boundary changed: {len(bank38_labels)} labels')
        return 1
    if '.DSB $4000 - $2b7b, $00' not in bank38_source or 'Bank38End::' not in bank38_source:
        print('FAIL bank38 is missing its end-label and linked-size assertion')
        return 1
    print('OK bank38 uses structured Text 7 include: 181 records, end/size assertions')

    bank39_text = Path('wla/banks/bank39_text.asm')
    bank39_source = banks[39].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank39_text.asm"' not in bank39_source:
        print('FAIL bank39 is not using its structured Text 8 include')
        return 1
    bank39_labels = file_labels(bank39_text)
    if len(bank39_labels) != 202 or bank39_labels[0] != '_VermilionGymLTSurgePostBattleAdviceText' or bank39_labels[-1] != 'Bank39TextEnd':
        print(f'FAIL structured bank39 label boundary changed: {len(bank39_labels)} labels')
        return 1
    if '.DSB $4000 - $2aa4, $00' not in bank39_source or 'Bank39End::' not in bank39_source:
        print('FAIL bank39 is missing its end-label and linked-size assertion')
        return 1
    print('OK bank39 uses structured Text 8 include: 201 records, end/size assertions')

    bank40_text = Path('wla/banks/bank40_text.asm')
    bank40_source = banks[40].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank40_text.asm"' not in bank40_source:
        print('FAIL bank40 is not using its structured Text 9 include')
        return 1
    bank40_labels = file_labels(bank40_text)
    if len(bank40_labels) != 207 or bank40_labels[0] != '_FuchsiaGymKogaPostBattleAdviceText' or bank40_labels[-1] != 'Bank40TextEnd':
        print(f'FAIL structured bank40 label boundary changed: {len(bank40_labels)} labels')
        return 1
    if '.DSB $4000 - $2a37, $00' not in bank40_source or 'Bank40End::' not in bank40_source:
        print('FAIL bank40 is missing its end-label and linked-size assertion')
        return 1
    print('OK bank40 uses structured Text 9 include: 206 records, end/size assertions')

    bank41_text = Path('wla/banks/bank41_text.asm')
    bank41_source = banks[41].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank41_text.asm"' not in bank41_source:
        print('FAIL bank41 is not using its structured Text 10 include')
        return 1
    bank41_labels = file_labels(bank41_text)
    if len(bank41_labels) != 222 or bank41_labels[0] != '_CableClubNPCPleaseComeAgainText' or bank41_labels[-1] != 'Bank41TextEnd':
        print(f'FAIL structured bank41 label boundary changed: {len(bank41_labels)} labels')
        return 1
    if '.DSB $4000 - $2b94, $00' not in bank41_source or 'Bank41End::' not in bank41_source:
        print('FAIL bank41 is missing its end-label and linked-size assertion')
        return 1
    print('OK bank41 uses structured Text 10 include: 221 records, end/size assertions')

    bank43_text = Path('wla/banks/bank43_dex_text.asm')
    bank43_source = banks[43].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank43_dex_text.asm"' not in bank43_source:
        print('FAIL bank43 is not using its structured Pokédex Text include')
        return 1
    bank43_labels = file_labels(bank43_text)
    if len(bank43_labels) != 152 or bank43_labels[0] != '_RhydonDexEntry' or bank43_labels[-1] != 'Bank43DexTextEnd':
        print(f'FAIL structured bank43 label boundary changed: {len(bank43_labels)} labels')
        return 1
    if '.DSB $4000 - $3838, $00' not in bank43_source or 'Bank43End::' not in bank43_source:
        print('FAIL bank43 is missing its end-label and linked-size assertion')
        return 1
    print('OK bank43 uses structured Pokédex Text include: 151 records, end/size assertions')

    bank44_names = Path('wla/banks/bank44_move_names.asm')
    bank44_source = banks[44].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank44_move_names.asm"' not in bank44_source:
        print('FAIL bank44 is not using its structured Move Names include')
        return 1
    bank44_labels = file_labels(bank44_names)
    if bank44_labels != ['MoveNames', 'Bank44MoveNamesEnd']:
        print(f'FAIL structured bank44 label boundary changed: {bank44_labels}')
        return 1
    move_name_count = bank44_names.read_text(errors='replace').count('.STRINGMAP pokemon,')
    if move_name_count != 165:
        print(f'FAIL structured bank44 move-name count changed: {move_name_count}')
        return 1
    if '.DSB $4000 - $060f, $00' not in bank44_source or 'Bank44End::' not in bank44_source:
        print('FAIL bank44 is missing its end-label and linked-size assertion')
        return 1
    print('OK bank44 uses structured Move Names include: 165 records, end/size assertions')

    starter_dex = Path('wla/banks/bank23_starter_dex.asm')
    bank23_source = banks[23].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank23_starter_dex.asm"' not in bank23_source:
        print('FAIL bank23 is not using its structured Starter Dex include')
        return 1
    if file_labels(starter_dex) != ['StarterDex', 'StarterDexEnd']:
        print('FAIL structured Starter Dex label boundary changed')
        return 1
    if '$3d ; ShowPokedexData predef ID' not in starter_dex.read_text(errors='replace'):
        print('FAIL structured Starter Dex lost its named predef ID')
        return 1
    print('OK bank23 uses structured Starter Dex include: 15-byte executable section')

    saffron_guards = Path('wla/banks/bank22_saffron_guards.asm')
    bank22_source = banks[22].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank22_saffron_guards.asm"' not in bank22_source:
        print('FAIL bank22 is not using its structured Saffron Guards include')
        return 1
    if file_labels(saffron_guards) != ['RemoveGuardDrink', 'RemoveGuardDrinkDrinkLoop', 'GuardDrinksList', 'SaffronGuardsEnd']:
        print('FAIL structured Saffron Guards label boundary changed')
        return 1
    print('OK bank22 uses structured Saffron Guards include: 28-byte executable/data section')

    music_headers_2 = Path('wla/banks/bank08_music_headers_2.asm')
    bank08_source = banks[8].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank08_music_headers_2.asm"' not in bank08_source:
        print('FAIL bank08 is not using its structured Music Headers 2 include')
        return 1
    music_header_labels = file_labels(music_headers_2)
    if len(music_header_labels) != 8 or music_header_labels[0] != 'Music_GymLeaderBattle' or music_header_labels[-1] != 'MusicHeaders2End':
        print(f'FAIL structured Music Headers 2 label boundary changed: {len(music_header_labels)} labels')
        return 1
    print('OK bank08 uses structured Music Headers 2 include: 7 headers, 63-byte section')

    sfx_headers_2 = Path('wla/banks/bank08_sfx_headers_2.asm')
    if '.INCLUDE "wla/banks/bank08_sfx_headers_2.asm"' not in bank08_source:
        print('FAIL bank08 is not using its structured Sound Effect Headers 2 include')
        return 1
    sfx_header_labels = file_labels(sfx_headers_2)
    if len(sfx_header_labels) != 121 or sfx_header_labels[0] != 'SFX_Headers_2' or sfx_header_labels[-1] != 'SfxHeaders2End':
        print(f'FAIL structured Sound Effect Headers 2 label boundary changed: {len(sfx_header_labels)} labels')
        return 1
    print('OK bank08 uses structured Sound Effect Headers 2 include: 119 headers, 702-byte section')

    low_health = Path('wla/banks/bank08_low_health_alarm.asm')
    if '.INCLUDE "wla/banks/bank08_low_health_alarm.asm"' not in bank08_source:
        print('FAIL bank08 is not using its structured Low Health Alarm include')
        return 1
    low_health_labels = file_labels(low_health)
    if len(low_health_labels) != 13 or low_health_labels[0] != 'Music_DoLowHealthAlarm' or low_health_labels[-1] != 'LowHealthAlarmEnd':
        print(f'FAIL structured Low Health Alarm label boundary changed: {len(low_health_labels)} labels')
        return 1
    print('OK bank08 uses structured Low Health Alarm include: 90-byte executable/data section')

    battle_engine_6 = Path('wla/banks/bank12_battle_engine_6.asm')
    bank12_source = banks[12].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank12_battle_engine_6.asm"' not in bank12_source:
        print('FAIL bank12 is not using its structured Battle Engine 6 include')
        return 1
    battle_engine_6_labels = file_labels(battle_engine_6)
    if len(battle_engine_6_labels) != 8 or battle_engine_6_labels[0] != 'MistEffect_' or battle_engine_6_labels[-1] != 'BattleEngine6End':
        print(f'FAIL structured Battle Engine 6 label boundary changed: {len(battle_engine_6_labels)} labels')
        return 1
    print('OK bank12 uses structured Battle Engine 6 include: 101-byte executable/text section')

    screen_effects = Path('wla/banks/bank18_screen_effects.asm')
    bank18_source = banks[18].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank18_screen_effects.asm"' not in bank18_source:
        print('FAIL bank18 is not using its structured Screen Effects include')
        return 1
    screen_effect_labels = file_labels(screen_effects)
    if len(screen_effect_labels) != 9 or screen_effect_labels[0] != 'ChangeBGPalColor0_4Frames' or screen_effect_labels[-1] != 'ScreenEffectsEnd':
        print(f'FAIL structured Screen Effects label boundary changed: {len(screen_effect_labels)} labels')
        return 1
    print('OK bank18 uses structured Screen Effects include: 103-byte executable section')

    play_time = Path('wla/banks/bank06_play_time.asm')
    bank06_source = banks[6].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank06_play_time.asm"' not in bank06_source:
        print('FAIL bank06 is not using its structured Play Time include')
        return 1
    play_time_labels = file_labels(play_time)
    if len(play_time_labels) != 5 or play_time_labels[0] != 'TrackPlayTime' or play_time_labels[-1] != 'PlayTimeEnd':
        print(f'FAIL structured Play Time label boundary changed: {len(play_time_labels)} labels')
        return 1
    print('OK bank06 uses structured Play Time include: 109-byte executable section')

    battle_engine_11 = Path('wla/banks/bank26_battle_engine_11.asm')
    bank26_source = banks[26].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank26_battle_engine_11.asm"' not in bank26_source:
        print('FAIL bank26 is not using its structured Battle Engine 11 include')
        return 1
    battle_engine_11_labels = file_labels(battle_engine_11)
    if len(battle_engine_11_labels) != 5 or battle_engine_11_labels[0] != 'DecrementPP' or battle_engine_11_labels[-1] != 'BattleEngine11End':
        print(f'FAIL structured Battle Engine 11 label boundary changed: {len(battle_engine_11_labels)} labels')
        return 1
    if '.INCBIN "gfx/title/red_version.1bpp"' not in battle_engine_11.read_text(errors='replace'):
        print('FAIL Battle Engine 11 is not using the reproducible Red version asset')
        return 1
    print('OK bank26 uses structured Battle Engine 11 include: 47-byte code + 80-byte asset')

    music_headers_3 = Path('wla/banks/bank31_music_headers_3.asm')
    bank31_source = banks[31].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank31_music_headers_3.asm"' not in bank31_source:
        print('FAIL bank31 is not using its structured Music Headers 3 include')
        return 1
    music_header_labels = file_labels(music_headers_3)
    if len(music_header_labels) != 19 or music_header_labels[0] != 'Music_TitleScreen' or music_header_labels[-1] != 'MusicHeaders3End':
        print(f'FAIL structured Music Headers 3 label boundary changed: {len(music_header_labels)} labels')
        return 1
    print('OK bank31 uses structured Music Headers 3 include: 18 headers, 180-byte section')

    sfx_headers_3 = Path('wla/banks/bank31_sfx_headers_3.asm')
    if '.INCLUDE "wla/banks/bank31_sfx_headers_3.asm"' not in bank31_source:
        print('FAIL bank31 is not using its structured Sound Effect Headers 3 include')
        return 1
    sfx_header_labels = file_labels(sfx_headers_3)
    if len(sfx_header_labels) != 105 or sfx_header_labels[0] != 'SFX_Headers_3' or sfx_header_labels[-1] != 'SfxHeaders3End':
        print(f'FAIL structured Sound Effect Headers 3 label boundary changed: {len(sfx_header_labels)} labels')
        return 1
    print('OK bank31 uses structured Sound Effect Headers 3 include: 103 headers, 585-byte section')

    music_headers_1 = Path('wla/banks/bank02_music_headers_1.asm')
    bank02_source = banks[2].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank02_music_headers_1.asm"' not in bank02_source:
        print('FAIL bank02 is not using its structured Music Headers 1 include')
        return 1
    music_header_labels = file_labels(music_headers_1)
    if len(music_header_labels) != 21 or music_header_labels[0] != 'Music_PalletTown' or music_header_labels[-1] != 'MusicHeaders1End':
        print(f'FAIL structured Music Headers 1 label boundary changed: {len(music_header_labels)} labels')
        return 1
    print('OK bank02 uses structured Music Headers 1 include: 20 headers, 207-byte section')

    sfx_headers_1 = Path('wla/banks/bank02_sfx_headers_1.asm')
    if '.INCLUDE "wla/banks/bank02_sfx_headers_1.asm"' not in bank02_source:
        print('FAIL bank02 is not using its structured Sound Effect Headers 1 include')
        return 1
    sfx_header_labels = file_labels(sfx_headers_1)
    if len(sfx_header_labels) != 97 or sfx_header_labels[0] != 'SFX_Headers_1' or sfx_header_labels[-1] != 'SfxHeaders1End':
        print(f'FAIL structured Sound Effect Headers 1 label boundary changed: {len(sfx_header_labels)} labels')
        return 1
    print('OK bank02 uses structured Sound Effect Headers 1 include: 95 headers, 558-byte section')

    if not args.monolith.is_file():
        print(f'FAIL monolith not found: {args.monolith}')
        return 1
    monolith_labels = labels_by_bank(args.monolith)
    if sorted(monolith_labels) != list(range(64)):
        print(f'FAIL monolith bank set is incomplete: {sorted(monolith_labels)}')
        return 1

    total_monolith_labels = 0
    total_split_labels = 0
    sample_failures: list[str] = []
    for i, bank_path in enumerate(banks):
        expected = monolith_labels.get(i, [])
        actual = set(file_labels_with_includes(bank_path))
        total_monolith_labels += len(expected)
        total_split_labels += len(actual)
        sample = expected[:10]
        missing_sample = [label for label in sample if label not in actual]
        if missing_sample:
            sample_failures.append(f'bank{i:02d}: ' + ', '.join(missing_sample[:5]))
    if sample_failures:
        print('FAIL representative monolith labels missing from split:')
        for failure in sample_failures[:20]:
            print(f'  {failure}')
        return 1

    print(f'OK representative monolith labels present in split banks: {total_monolith_labels} monolith labels indexed, {total_split_labels} split labels indexed')

    reconcile_result = audit_reconcile_tree()
    print_reconcile_audit(reconcile_result)
    if not reconcile_result.ok:
        return 1

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
