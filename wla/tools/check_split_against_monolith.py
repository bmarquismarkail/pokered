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

    maps_7 = Path('wla/banks/bank18_maps_7.asm')
    if '.INCLUDE "wla/banks/bank18_maps_7.asm"' not in bank18_source:
        print('FAIL bank18 is not using its structured Maps 7 include')
        return 1
    maps_7_labels = file_labels(maps_7)
    if len(maps_7_labels) != 15 or maps_7_labels[0] != 'Route7_h' or maps_7_labels[-1] != 'Maps7End':
        print(f'FAIL structured Maps 7 label boundary changed: {len(maps_7_labels)} labels')
        return 1
    if maps_7.read_text(errors='replace').count('.INCBIN "maps/') != 4:
        print('FAIL Maps 7 must reference exactly four reproducible map assets')
        return 1
    print('OK bank18 uses structured Maps 7 include: Route 7 + 4 assets, 235-byte section')

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

    leech_seed = Path('wla/banks/bank10_leech_seed.asm')
    bank10_source = banks[10].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank10_leech_seed.asm"' not in bank10_source:
        print('FAIL bank10 is not using its structured Battle Engine 4 include')
        return 1
    leech_seed_labels = file_labels(leech_seed)
    if len(leech_seed_labels) != 6 or leech_seed_labels[0] != 'LeechSeedEffect_' or leech_seed_labels[-1] != 'LeechSeedSectionEnd':
        print(f'FAIL structured Battle Engine 4 label boundary changed: {len(leech_seed_labels)} labels')
        return 1
    print('OK bank10 uses structured Battle Engine 4 include: 83-byte executable/text section')

    maps_3 = Path('wla/banks/bank07_maps_3.asm')
    bank07_source = banks[7].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank07_maps_3.asm"' not in bank07_source:
        print('FAIL bank07 is not using its structured Maps 3 include')
        return 1
    maps_3_labels = file_labels(maps_3)
    if len(maps_3_labels) != 26 or maps_3_labels[0] != 'CinnabarIsland_h' or maps_3_labels[-1] != 'Maps3End':
        print(f'FAIL structured Maps 3 label boundary changed: {len(maps_3_labels)} labels')
        return 1
    if maps_3.read_text(errors='replace').count('.INCBIN "maps/') != 8:
        print('FAIL Maps 3 must reference exactly eight reproducible map assets')
        return 1
    print('OK bank07 uses structured Maps 3 include: 2 maps + 8 assets, 542-byte section')

    battle_engine_3 = Path('wla/banks/bank09_battle_engine_3.asm')
    bank09_source = banks[9].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank09_battle_engine_3.asm"' not in bank09_source:
        print('FAIL bank09 is not using its structured Battle Engine 3 include')
        return 1
    battle_engine_3_labels = file_labels(battle_engine_3)
    if len(battle_engine_3_labels) != 12 or battle_engine_3_labels[0] != 'PrintMonType' or battle_engine_3_labels[-1] != 'BattleEngine3End':
        print(f'FAIL structured Battle Engine 3 label boundary changed: {len(battle_engine_3_labels)} global labels')
        return 1
    battle_engine_3_source = battle_engine_3.read_text(errors='replace')
    if '.STRINGMAPTABLE pokemon "wla/pokemon.tbl"' not in battle_engine_3_source:
        print('FAIL Battle Engine 3 is not using the synchronized Pokemon string map')
        return 1
    if battle_engine_3_source.count('TrainerNamePointers.') < 21:
        print('FAIL Battle Engine 3 lost named trainer-name records')
        return 1
    print('OK bank09 uses structured Battle Engine 3 include: type/trainer tables + Focus Energy, 589-byte section')

    maps_19 = Path('wla/banks/bank29_maps_19.asm')
    bank29_source = banks[29].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank29_maps_19.asm"' not in bank29_source:
        print('FAIL bank29 is not using its structured Maps 19 include')
        return 1
    maps_19_labels = file_labels(maps_19)
    if len(maps_19_labels) != 8 or maps_19_labels[0] != 'CopycatsHouse1F_Blocks' or maps_19_labels[-1] != 'Maps19End':
        print(f'FAIL structured Maps 19 label boundary changed: {len(maps_19_labels)} labels')
        return 1
    if maps_19.read_text(errors='replace').count('.INCBIN "maps/') != 5:
        print('FAIL Maps 19 must reference exactly five reproducible map assets')
        return 1
    print('OK bank29 uses structured Maps 19 include: 5 assets, 92-byte section')

    vending_machine = Path('wla/banks/bank29_vending_machine.asm')
    if '.INCLUDE "wla/banks/bank29_vending_machine.asm"' not in bank29_source:
        print('FAIL bank29 is not using its structured Vending Machine include')
        return 1
    vending_machine_labels = file_labels(vending_machine)
    if len(vending_machine_labels) != 11 or vending_machine_labels[0] != 'VendingMachineMenu' or vending_machine_labels[-1] != 'VendingMachineEnd':
        print(f'FAIL structured Vending Machine label boundary changed: {len(vending_machine_labels)} global labels')
        return 1
    vending_machine_source = vending_machine.read_text(errors='replace')
    expected_local_labels = (
        'VendingMachineMenu.enoughMoney:',
        'VendingMachineMenu.playDeliverySound:',
        'VendingMachineMenu.BagFull:',
        'VendingMachineMenu.notThirsty:',
    )
    if any(label not in vending_machine_source for label in expected_local_labels):
        print('FAIL Vending Machine is missing an authoritative local label')
        return 1
    if '.STRINGMAPTABLE pokemon "wla/pokemon.tbl"' not in vending_machine_source:
        print('FAIL Vending Machine is not using the synchronized Pokemon string map')
        return 1
    print('OK bank29 uses structured Vending Machine include: native purchase logic + BCD prices, 300-byte section')

    maps_9 = Path('wla/banks/bank19_maps_9.asm')
    bank19_source = banks[19].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank19_maps_9.asm"' not in bank19_source:
        print('FAIL bank19 is not using its structured Maps 9 include')
        return 1
    maps_9_labels = file_labels(maps_9)
    if len(maps_9_labels) != 14 or maps_9_labels[0] != 'TradeCenter_h' or maps_9_labels[-1] != 'Maps9End':
        print(f'FAIL structured Maps 9 label boundary changed: {len(maps_9_labels)} labels')
        return 1
    if maps_9.read_text(errors='replace').count('.INCBIN "maps/') != 2:
        print('FAIL Maps 9 must reference exactly two reproducible map assets')
        return 1
    print('OK bank19 uses structured Maps 9 include: 2 link-room maps, 161-byte section')

    predefs = Path('wla/banks/bank19_predefs.asm')
    if '.INCLUDE "wla/banks/bank19_predefs.asm"' not in bank19_source:
        print('FAIL bank19 is not using its structured Predefs include')
        return 1
    predefs_labels = file_labels(predefs)
    if len(predefs_labels) != 107 or predefs_labels[0] != '_GivePokemon' or predefs_labels[-1] != 'PredefsEnd':
        print(f'FAIL structured Predefs label boundary changed: {len(predefs_labels)} global labels')
        return 1
    predefs_source = predefs.read_text(errors='replace')
    if predefs_source.count('Predef:') != 99:
        print('FAIL Predefs must retain exactly 99 named pointer records')
        return 1
    print('OK bank19 uses structured Predefs include: native give-Pokemon logic + 99 records, 509-byte section')

    battle_engine_8 = Path('wla/banks/bank20_battle_engine_8.asm')
    bank20_source = banks[20].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank20_battle_engine_8.asm"' not in bank20_source:
        print('FAIL bank20 is not using its structured Battle Engine 8 include')
        return 1
    battle_engine_8_labels = file_labels(battle_engine_8)
    if len(battle_engine_8_labels) != 3 or battle_engine_8_labels[0] != 'InitBattleVariables' or battle_engine_8_labels[-1] != 'BattleEngine8End':
        print(f'FAIL structured Battle Engine 8 label boundary changed: {len(battle_engine_8_labels)} global labels')
        return 1
    expected_local_labels = (
        'InitBattleVariables.loop:',
        'InitBattleVariables.notSafariBattle:',
        'ParalyzeEffect_.next:',
        'ParalyzeEffect_.hitTest:',
        'ParalyzeEffect_.didntAffect:',
        'ParalyzeEffect_.doesntAffect:',
    )
    battle_engine_8_source = battle_engine_8.read_text(errors='replace')
    if any(label not in battle_engine_8_source for label in expected_local_labels):
        print('FAIL Battle Engine 8 is missing an authoritative local label')
        return 1
    print('OK bank20 uses structured Battle Engine 8 include: 196-byte executable section')

    bank17_source = banks[17].read_text(errors='replace')
    maps_5 = Path('wla/banks/bank17_maps_5.asm')
    if '.INCLUDE "wla/banks/bank17_maps_5.asm"' not in bank17_source:
        print('FAIL bank17 is not using its structured Maps 5 include')
        return 1
    maps_5_labels = file_labels(maps_5)
    if len(maps_5_labels) != 18 or maps_5_labels[0] != 'LavenderTown_h' or maps_5_labels[-1] != 'Maps5End':
        print(f'FAIL structured Maps 5 label boundary changed: {len(maps_5_labels)} global labels')
        return 1
    maps_5_source = maps_5.read_text(errors='replace')
    expected_maps_5_locals = (
        'LavenderTownLittleGirlText.got_text:',
        'LavenderTownLittleGirlText.DoYouBelieveInGhostsText:',
        'LavenderTownLittleGirlText.SoThereAreBelieversText:',
        'LavenderTownLittleGirlText.HaHaGuessNotText:',
    )
    if any(label not in maps_5_source for label in expected_maps_5_locals):
        print('FAIL Maps 5 is missing an authoritative local label')
        return 1
    if maps_5_source.count('.INCBIN "maps/') != 3:
        print('FAIL Maps 5 must reference exactly three reproducible map assets')
        return 1
    print('OK bank17 uses structured Maps 5 include: Lavender Town + 3 assets, 361-byte section')

    pokedex_rating = Path('wla/banks/bank17_pokedex_rating.asm')
    if '.INCLUDE "wla/banks/bank17_pokedex_rating.asm"' not in bank17_source:
        print('FAIL bank17 is not using its structured Pokédex Rating include')
        return 1
    pokedex_rating_labels = file_labels(pokedex_rating)
    if len(pokedex_rating_labels) != 20 or pokedex_rating_labels[0] != 'DisplayDexRating' or pokedex_rating_labels[-1] != 'PokedexRatingEnd':
        print(f'FAIL structured Pokédex Rating label boundary changed: {len(pokedex_rating_labels)} global labels')
        return 1
    expected_rating_locals = (
        'DisplayDexRating.findRating:',
        'DisplayDexRating.foundRating:',
        'DisplayDexRating.hallOfFame:',
        'DisplayDexRating.copyRatingTextLoop:',
        'DisplayDexRating.doneCopying:',
    )
    pokedex_rating_source = pokedex_rating.read_text(errors='replace')
    if any(label not in pokedex_rating_source for label in expected_rating_locals):
        print('FAIL Pokédex Rating is missing an authoritative local label')
        return 1
    print('OK bank17 uses structured Pokédex Rating include: native logic + 16 ratings, 232-byte section')

    maps_15 = Path('wla/banks/bank23_maps_15.asm')
    if '.INCLUDE "wla/banks/bank23_maps_15.asm"' not in bank23_source:
        print('FAIL bank23 is not using its structured Maps 15 include')
        return 1
    maps_15_labels = file_labels(maps_15)
    if len(maps_15_labels) != 27 or maps_15_labels[0] != 'SaffronMart_Blocks' or maps_15_labels[-1] != 'Maps15End':
        print(f'FAIL structured Maps 15 label boundary changed: {len(maps_15_labels)} labels')
        return 1
    if maps_15.read_text(errors='replace').count('.INCBIN "maps/') != 7:
        print('FAIL Maps 15 must reference exactly seven reproducible map assets')
        return 1
    print('OK bank23 uses structured Maps 15 include: 7 assets + Red\'s House 2F, 220-byte section')

    cinnabar_lab_fossils = Path('wla/banks/bank24_cinnabar_lab_fossils.asm')
    bank24_source = banks[24].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank24_cinnabar_lab_fossils.asm"' not in bank24_source:
        print('FAIL bank24 is not using its structured Cinnabar Lab Fossils include')
        return 1
    cinnabar_lab_labels = file_labels(cinnabar_lab_fossils)
    if len(cinnabar_lab_labels) != 4 or cinnabar_lab_labels[0] != 'GiveFossilToCinnabarLab' or cinnabar_lab_labels[-1] != 'CinnabarLabFossilsEnd':
        print(f'FAIL structured Cinnabar Lab Fossils label boundary changed: {len(cinnabar_lab_labels)} global labels')
        return 1
    expected_cinnabar_locals = (
        'GiveFossilToCinnabarLab.choseHelixFossil:',
        'GiveFossilToCinnabarLab.choseDomeFossil:',
        'GiveFossilToCinnabarLab.fossilSelected:',
        'GiveFossilToCinnabarLab.cancelledGivingFossil:',
        'GiveFossilToCinnabarLab.ScientistSeesFossilText:',
        'GiveFossilToCinnabarLab.ScientistTakesFossilText:',
        'GiveFossilToCinnabarLab.GoForAWalkText:',
        'GiveFossilToCinnabarLab.ComeAgainText:',
        'PrintFossilsInBag.loop:',
    )
    cinnabar_lab_source = cinnabar_lab_fossils.read_text(errors='replace')
    if any(label not in cinnabar_lab_source for label in expected_cinnabar_locals):
        print('FAIL Cinnabar Lab Fossils is missing an authoritative local label')
        return 1
    print('OK bank24 uses structured Cinnabar Lab Fossils include: native menu/revival logic, 251-byte section')

    hidden_events_4 = Path('wla/banks/bank24_hidden_events_4.asm')
    if '.INCLUDE "wla/banks/bank24_hidden_events_4.asm"' not in bank24_source:
        print('FAIL bank24 is not using its structured Hidden Events 4 include')
        return 1
    hidden_events_4_labels = file_labels(hidden_events_4)
    if len(hidden_events_4_labels) != 29 or hidden_events_4_labels[0] != 'GymStatues' or hidden_events_4_labels[-1] != 'HiddenEvents4End':
        print(f'FAIL structured Hidden Events 4 label boundary changed: {len(hidden_events_4_labels)} global labels')
        return 1
    expected_hidden_events_4_locals = (
        'GymStatues.loop:',
        'GymStatues.match:',
        'GymStatues.haveBadge:',
        'PrintBenchGuyText.loop:',
        'PrintBenchGuyText.match:',
        'SaffronCityPokecenterBenchGuyText.printText:',
    )
    hidden_events_4_source = hidden_events_4.read_text(errors='replace')
    if any(label not in hidden_events_4_source for label in expected_hidden_events_4_locals):
        print('FAIL Hidden Events 4 is missing an authoritative local label')
        return 1
    print('OK bank24 uses structured Hidden Events 4 include: 4 event systems + text/data, 273-byte section')

    diploma = Path('wla/banks/bank21_diploma.asm')
    bank21_source = banks[21].read_text(errors='replace')
    if '.INCLUDE "wla/banks/bank21_diploma.asm"' not in bank21_source:
        print('FAIL bank21 is not using its structured Diploma include')
        return 1
    diploma_labels = file_labels(diploma)
    if len(diploma_labels) != 9 or diploma_labels[0] != 'DisplayDiploma' or diploma_labels[-1] != 'DiplomaEnd':
        print(f'FAIL structured Diploma label boundary changed: {len(diploma_labels)} global labels')
        return 1
    expected_diploma_locals = (
        'DisplayDiploma.placeTextLoop:',
        'DisplayDiploma.adjustPlayerGfxLoop:',
        'UnusedPlayerNameLengthFunc.loop:',
    )
    diploma_source = diploma.read_text(errors='replace')
    if any(label not in diploma_source for label in expected_diploma_locals):
        print('FAIL Diploma is missing an authoritative local label')
        return 1
    if '.STRINGMAPTABLE pokemon "wla/pokemon.tbl"' not in diploma_source:
        print('FAIL Diploma is not using the synchronized Pokemon string map')
        return 1
    print('OK bank21 uses structured Diploma include: native rendering + charmap text, 279-byte section')

    battle_engine_9 = Path('wla/banks/bank21_battle_engine_9.asm')
    if '.INCLUDE "wla/banks/bank21_battle_engine_9.asm"' not in bank21_source:
        print('FAIL bank21 is not using its structured Battle Engine 9 include')
        return 1
    battle_engine_9_labels = file_labels(battle_engine_9)
    if len(battle_engine_9_labels) != 9 or battle_engine_9_labels[0] != 'GainExperience' or battle_engine_9_labels[-1] != 'BattleEngine9End':
        print(f'FAIL structured Battle Engine 9 label boundary changed: {len(battle_engine_9_labels)} global labels')
        return 1
    battle_engine_9_source = battle_engine_9.read_text(errors='replace')
    expected_battle_engine_9_locals = (
        'GainExperience.partyMonLoop:',
        'GainExperience.recalcStatChanges:',
        'GainExperience.nextMon:',
        'DivideExpDataByNumMonsGainingExp.divideLoop:',
    )
    if any(label not in battle_engine_9_source for label in expected_battle_engine_9_locals):
        print('FAIL Battle Engine 9 is missing an authoritative local label')
        return 1
    print('OK bank21 uses structured Battle Engine 9 include: native experience/level-up logic, 660-byte section')

    trainer_sight = Path('wla/banks/bank21_trainer_sight.asm')
    if '.INCLUDE "wla/banks/bank21_trainer_sight.asm"' not in bank21_source:
        print('FAIL bank21 is not using its structured Trainer Sight include')
        return 1
    trainer_sight_labels = file_labels(trainer_sight)
    if len(trainer_sight_labels) != 11 or trainer_sight_labels[0] != '_GetSpritePosition1' or trainer_sight_labels[-1] != 'TrainerSightEnd':
        print(f'FAIL structured Trainer Sight label boundary changed: {len(trainer_sight_labels)} global labels')
        return 1
    trainer_sight_source = trainer_sight.read_text(errors='replace')
    expected_trainer_sight_locals = (
        'TrainerWalkUpToPlayer.writeWalkScript:',
        'TrainerEngage.engage:',
        'CheckSpriteCanSeePlayer.inLine:',
        'CheckPlayerIsInFrontOfSprite.done:',
    )
    if any(label not in trainer_sight_source for label in expected_trainer_sight_locals):
        print('FAIL Trainer Sight is missing an authoritative local label')
        return 1
    print('OK bank21 uses structured Trainer Sight include: native positioning/engagement logic, 594-byte section')

    migrated_sections = (
        (2, 'wla/build/bank02_sound_effects_1.asm', 'SFX_Noise_Instrument01_1_Ch8', 'AudioSectionEnd1', 178, 3529, 'Sound Effects 1'),
        (8, 'wla/build/bank08_sound_effects_2.asm', 'SFX_Noise_Instrument01_2_Ch8', 'AudioSectionEnd2', 230, 4209, 'Sound Effects 2'),
        (31, 'wla/build/bank31_sound_effects_3.asm', 'SFX_Noise_Instrument01_3_Ch8', 'AudioSectionEnd3', 187, 3646, 'Sound Effects 3'),
        (5, 'bank05_battle_engine_2.asm', 'LoadPokedexTilePatterns', 'BattleEngine2End', 35, 1823, 'Battle Engine 2'),
        (8, 'bank08_bills_pc.asm', 'DisplayPCMainMenu', 'BillsPCEnd', 41, 1201, 'Bills PC'),
        (11, 'bank11_battle_engine_5.asm', 'DisplayEffectiveness', 'BattleEngine5End', 21, 961, 'Battle Engine 5'),
        (20, 'bank20_hidden_events_2.asm', 'PrintCardKeyText', 'HiddenEvents2End', 48, 975, 'Hidden Events 2'),
        (29, 'bank29_itemfinder_1.asm', 'HallOfFamePC', 'Itemfinder1End', 85, 2070, 'Itemfinder 1'),
        (17, 'bank17_hidden_events_core.asm', 'IsPlayerOnDungeonWarp', 'HiddenEventsCoreEnd', 91, 1834, 'Hidden Events Core'),
        (7, 'bank07_pokemon_names.asm', 'MonsterNames', 'PokemonNamesEnd', 6, 2043, 'Pokémon Names'),
        (29, 'bank29_itemfinder_2.asm', 'PKMNLeaguePC', 'Itemfinder2End', 15, 765, 'Itemfinder 2'),
        (22, 'bank22_battle_engine_10.asm', 'PrintBeginningBattleText', 'BattleEngine10End', 33, 791, 'Battle Engine 10'),
        (6, 'bank06_doors_and_ledges.asm', 'PlayerStepOutFromDoor', 'DoorsAndLedgesEnd', 30, 824, 'Doors and Ledges'),
        (7, 'bank07_hidden_events_1.asm', 'OpenOaksPC', 'HiddenEvents1End', 47, 941, 'Hidden Events 1'),
        (23, 'bank23_hidden_events_3.asm', 'SetPartyMonTypes', 'HiddenEvents3End', 42, 951, 'Hidden Events 3'),
    )
    for bank, filename, first, last, count, size, description in migrated_sections:
        section = Path(filename) if filename.startswith('wla/') else Path('wla/banks') / filename
        include = f'.INCLUDE "{section}"'
        if include not in banks[bank].read_text(errors='replace'):
            print(f'FAIL bank{bank:02d} is not using its structured {description} include')
            return 1
        labels = file_labels(section)
        if len(labels) != count or labels[0] != first or labels[-1] != last:
            print(f'FAIL structured {description} label boundary changed: {len(labels)} global labels')
            return 1
        print(f'OK bank{bank:02d} uses structured {description} include: {size}-byte source-driven section')

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
