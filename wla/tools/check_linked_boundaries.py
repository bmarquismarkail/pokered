#!/usr/bin/env python3
"""Verify linked addresses and sizes of structured WLA-DX sections."""

from __future__ import annotations

import re
import sys
from pathlib import Path


EXPECTED = (
    ('Vitamin Stats', 0x03, 'VitaminStats', 0x5F2E, 'VitaminStatsEnd', 0x5F51),
    ('Stat Modifier Names', 0x0F, 'StatModTextStrings', 0x769F, 'StatModTextStringsEnd', 0x76CB),
    ('Type Names', 0x09, 'TypeNames', 0x7DAE, 'TypeNamesEnd', 0x7E4A),
    ('Saffron Guards', 0x16, 'RemoveGuardDrink', 0x659F, 'SaffronGuardsEnd', 0x65BB),
    ('Starter Dex', 0x17, 'StarterDex', 0x40DC, 'StarterDexEnd', 0x40EB),
    ('Maps 15', 0x17, 'SaffronMart_Blocks', 0x4000, 'Maps15End', 0x40DC),
    ('Maps 9', 0x13, 'TradeCenter_h', 0x7D04, 'Maps9End', 0x7DA5),
    ('Maps 19', 0x1D, 'CopycatsHouse1F_Blocks', 0x4000, 'Maps19End', 0x405C),
    ('Predefs', 0x13, '_GivePokemon', 0x7DA5, 'PredefsEnd', 0x7FA2),
    ('Battle Engine 11', 0x1A, 'DecrementPP', 0x4000, 'BattleEngine11End', 0x407F),
    ('Version Graphics', 0x1A, 'Version_GFX', 0x402F, 'Version_GFXEnd', 0x407F),
    ('Leech Seed', 0x0A, 'LeechSeedEffect_', 0x7EA9, 'LeechSeedSectionEnd', 0x7EFC),
    ('Low Health Alarm', 0x08, 'Music_DoLowHealthAlarm', 0x536E, 'LowHealthAlarmEnd', 0x53C8),
    ('Battle Engine 6', 0x0C, 'MistEffect_', 0x7F2B, 'BattleEngine6End', 0x7F90),
    ('Music Headers 1', 0x02, 'Music_PalletTown', 0x422E, 'MusicHeaders1End', 0x42FD),
    ('Music Headers 2', 0x08, 'Music_GymLeaderBattle', 0x42BE, 'MusicHeaders2End', 0x42FD),
    ('Music Headers 3', 0x1F, 'Music_TitleScreen', 0x4249, 'MusicHeaders3End', 0x42FD),
    ('Sound Effects 1', 0x02, 'SFX_Noise_Instrument01_1_Ch8', 0x42FD, 'AudioSectionEnd1', 0x50C6),
    ('Sound Effects 2', 0x08, 'SFX_Noise_Instrument01_2_Ch8', 0x42FD, 'AudioSectionEnd2', 0x536E),
    ('Sound Effects 3', 0x1F, 'SFX_Noise_Instrument01_3_Ch8', 0x42FD, 'AudioSectionEnd3', 0x513B),
    ('Battle Engine 2', 0x05, 'LoadPokedexTilePatterns', 0x7840, 'BattleEngine2End', 0x7F5F),
    ('Bills PC', 0x08, 'DisplayPCMainMenu', 0x53C8, 'BillsPCEnd', 0x5879),
    ('Battle Engine 5', 0x0B, 'DisplayEffectiveness', 0x7B7B, 'BattleEngine5End', 0x7F3C),
    ('Hidden Events 2', 0x14, 'PrintCardKeyText', 0x6673, 'HiddenEvents2End', 0x6A42),
    ('Itemfinder 1', 0x1D, 'HallOfFamePC', 0x405C, 'Itemfinder1End', 0x4872),
    ('Hidden Events Core', 0x11, 'IsPlayerOnDungeonWarp', 0x6981, 'HiddenEventsCoreEnd', 0x70AB),
    ('Pokémon Names', 0x07, 'MonsterNames', 0x421E, 'PokemonNamesEnd', 0x4A19),
    ('Doors and Ledges', 0x06, 'PlayerStepOutFromDoor', 0x63E0, 'DoorsAndLedgesEnd', 0x6718),
    ('Hidden Events 1', 0x07, 'OpenOaksPC', 0x6915, 'HiddenEvents1End', 0x6CC2),
    ('Battle Engine 10', 0x16, 'PrintBeginningBattleText', 0x4D99, 'BattleEngine10End', 0x50B0),
    ('Hidden Events 3', 0x17, 'SetPartyMonTypes', 0x5B5E, 'HiddenEvents3End', 0x5F15),
    ('Itemfinder 2', 0x1D, 'PKMNLeaguePC', 0x657E, 'Itemfinder2End', 0x687B),
    ('Pewter Guys', 0x0D, '+PewterGuys', 0x7CA1, 'PewterGuysEnd', 0x7D41),
    ('Multiply', 0x0D, '+_Multiply', 0x7D41, 'MultiplyEnd', 0x7DA5),
    ('Start Slot Machine', 0x0D, '+StartSlotMachine', 0x7E2D, 'StartSlotMachineEnd', 0x7E88),
    ('Title 2', 0x0D, 'TitleScroll_WaitBall', 0x7244, 'Title2End', 0x72D6),
    ('Link Battle Versus Text', 0x0D, 'DisplayLinkBattleVersusTextBox', 0x72D6, 'LinkVersusEnd', 0x730E),
    ('Slot Machine Tiles 1', 0x0D, 'SlotMachineTiles1', 0x7A51, 'SlotMachineTiles1End', 0x7CA1),
    ('Slot Machine Tiles 2', 0x1E, 'SlotMachineTiles2', 0x4BDE, 'SlotMachineTiles2End', 0x4D5E),
    ('Slot Machine Wheel 1', 0x0D, 'SlotMachineWheel1', 0x79E5, 'SlotMachineWheel1End', 0x7A09),
    ('Slot Machine Wheel 2', 0x0D, 'SlotMachineWheel2', 0x7A09, 'SlotMachineWheel2End', 0x7A2D),
    ('Slot Machine Wheel 3', 0x0D, 'SlotMachineWheel3', 0x7A2D, 'SlotMachineWheel3End', 0x7A51),
    ('Slot Machine Map', 0x0D, 'SlotMachineMap', 0x78F5, 'SlotMachineMapEnd', 0x79E5),
    ('Load Slot Machine Tiles', 0x0D, '+LoadSlotMachineTiles', 0x78A8, 'LoadSlotMachineTilesEnd', 0x78F5),
    ('Slot Wheel Animation', 0x0D, 'SlotMachine_AnimWheel1', 0x7813, 'SlotWheelAnimationEnd', 0x78A8),
    ('Print Winning Symbol', 0x0D, 'SlotMachine_PrintWinningSymbol', 0x7728, 'SlotMachinePrintWinningSymbolEnd', 0x7741),
    ('Print Credit Coins', 0x0D, 'SlotMachine_PrintCreditCoins', 0x7754, 'SlotMachinePrintCreditCoinsEnd', 0x775F),
    ('Print Payout Coins', 0x0D, 'SlotMachine_PrintPayoutCoins', 0x775F, 'SlotMachinePrintPayoutCoinsEnd', 0x776B),
    ('Put Out Lit Balls', 0x0D, 'SlotMachine_PutOutLitBalls', 0x77CE, 'SlotMachinePutOutLitBallsEnd', 0x77D5),
    ('Light Slot Balls', 0x0D, 'SlotMachine_LightBalls', 0x77D5, 'SlotMachineLightBallsEnd', 0x77E3),
    ('Update Coin Ball Tiles', 0x0D, 'SlotMachine_UpdateThreeCoinBallTiles', 0x77E3, 'SlotMachine_UpdateBallTilesEnd', 0x7813),
    ('Yeah Text', 0x0D, 'YeahText', 0x7722, 'YeahTextEnd', 0x7728),
    ('Slot Reward 300', 0x0D, 'SlotReward300Func', 0x7702, 'SlotReward300FuncEnd', 0x7722),
    ('Subtract Bet', 0x0D, 'SlotMachine_SubtractBetFromPlayerCoins', 0x7741, 'SlotMachine_SubtractBetFromPlayerCoinsEnd', 0x7754),
    ('Slot Reward 8', 0x0D, 'SlotReward8Func', 0x76D7, 'SlotReward8FuncEnd', 0x76E5),
    ('Slot Reward 15', 0x0D, 'SlotReward15Func', 0x76E5, 'SlotReward15FuncEnd', 0x76F3),
    ('Slot Reward 100', 0x0D, 'SlotReward100Func', 0x76F3, 'SlotReward100FuncEnd', 0x7702),
    ('Slot Reward Text', 0x0D, 'SlotReward300Text', 0x7690, 'SlotRewardTextEnd', 0x76A2),
    ('Check For Match', 0x0D, 'SlotMachine_CheckForMatch', 0x76A2, 'SlotMachine_CheckForMatchEnd', 0x76A8),
)


def main() -> int:
    symbols: dict[str, tuple[int, int]] = {}
    for line in Path(sys.argv[1]).read_text().splitlines():
        match = re.match(r'^([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4}) (\S+)$', line)
        if match:
            symbols[match.group(3)] = (int(match.group(1), 16), int(match.group(2), 16))
    for description, bank, start_label, start, end_label, end in EXPECTED:
        if symbols.get(start_label) != (bank, start) or symbols.get(end_label) != (bank, end):
            print(f'FAIL linked boundary changed for {description}')
            return 1
        print(f'OK linked {description}: bank {bank:02x}, {end - start}-byte boundary')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
