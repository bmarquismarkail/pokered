PokemonMansion3F_Script:
	call Mansion3CheckReplaceSwitchDoorBlocks
	call EnableAutoTextBoxDrawing
	ld hl, Mansion3TrainerHeaders
	ld de, PokemonMansion3F_ScriptPointers
	ld a, [wPokemonMansion3FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonMansion3FCurScript], a
	ret

Mansion3CheckReplaceSwitchDoorBlocks:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, Mansion3CheckReplaceSwitchDoorBlocks.switchTurnedOn
	ld a, $e
	lb "bc", 2, 7
	call Mansion2ReplaceBlock
	ld a, $5f
	lb "bc", 5, 7
	call Mansion2ReplaceBlock
	ret
Mansion3CheckReplaceSwitchDoorBlocks.switchTurnedOn
	ld a, $5f
	lb "bc", 2, 7
	call Mansion2ReplaceBlock
	ld a, $e
	lb "bc", 5, 7
	call Mansion2ReplaceBlock
	ret

PokemonMansion3F_ScriptPointers:
	def_script_pointers
	dw_const PokemonMansion3FDefaultScript,         SCRIPT_POKEMONMANSION3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONMANSION3F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_POKEMONMANSION3F_END_BATTLE

PokemonMansion3FDefaultScript:
	ld hl, PokemonMansion3FDefaultScript.holeCoords
	call PokemonMansion3FDefaultScript.isPlayerFallingDownHole
	ld a, [wWhichDungeonWarp]
	and a
	jp z, CheckFightingMapTrainers
	cp $3
	ld a, POKEMON_MANSION_1F
	jr nz, PokemonMansion3FDefaultScript.fellDownHoleTo1F
	ld a, POKEMON_MANSION_2F
PokemonMansion3FDefaultScript.fellDownHoleTo1F
	ld [wDungeonWarpDestinationMap], a
	ret

PokemonMansion3FDefaultScript.holeCoords:
	dbmapcoord 16, 14
	dbmapcoord 17, 14
	dbmapcoord 19, 14
	.DB -1 ; end

PokemonMansion3FDefaultScript.isPlayerFallingDownHole:
	xor a
	ld [wWhichDungeonWarp], a
	ld a, [wStatusFlags3]
	bit BIT_ON_DUNGEON_WARP, a
	ret nz
	call ArePlayerCoordsInArray
	ret nc
	ld a, [wCoordIndex]
	ld [wWhichDungeonWarp], a
	ld hl, wStatusFlags3
	set BIT_ON_DUNGEON_WARP, [hl]
	ld hl, wStatusFlags6
	set BIT_DUNGEON_WARP, [hl]
	ret

Mansion3Script_Switches:
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld a, TEXT_POKEMONMANSION3F_SWITCH
	ldh [lobyte(hTextID)], a
	jp DisplayTextID

PokemonMansion3F_TextPointers:
	def_text_pointers
	dw_const PokemonMansion3FSuperNerdText, TEXT_POKEMONMANSION3F_SUPER_NERD
	dw_const PokemonMansion3FScientistText, TEXT_POKEMONMANSION3F_SCIENTIST
	dw_const PickUpItemText,                TEXT_POKEMONMANSION3F_MAX_POTION
	dw_const PickUpItemText,                TEXT_POKEMONMANSION3F_IRON
	dw_const PokemonMansion3FDiaryText,     TEXT_POKEMONMANSION3F_DIARY
	dw_const PokemonMansion2FSwitchText,    TEXT_POKEMONMANSION3F_SWITCH ; This switch uses the text script from the 2F.

Mansion3TrainerHeaders:
	def_trainers
Mansion3TrainerHeader0:
	trainer EVENT_BEAT_MANSION_3_TRAINER_0, 0, PokemonMansion3FSuperNerdBattleText, PokemonMansion3FSuperNerdEndBattleText, PokemonMansion3FSuperNerdAfterBattleText
Mansion3TrainerHeader1:
	trainer EVENT_BEAT_MANSION_3_TRAINER_1, 2, PokemonMansion3FScientistBattleText, PokemonMansion3FScientistEndBattleText, PokemonMansion3FScientistAfterBattleText
	.DB -1 ; end

PokemonMansion3FSuperNerdText:
	text_asm
	ld hl, Mansion3TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonMansion3FScientistText:
	text_asm
	ld hl, Mansion3TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonMansion3FSuperNerdBattleText:
	text_far WLA_GLOBAL_PokemonMansion3FSuperNerdBattleText
	text_end

PokemonMansion3FSuperNerdEndBattleText:
	text_far WLA_GLOBAL_PokemonMansion3FSuperNerdEndBattleText
	text_end

PokemonMansion3FSuperNerdAfterBattleText:
	text_far WLA_GLOBAL_PokemonMansion3FSuperNerdAfterBattleText
	text_end

PokemonMansion3FScientistBattleText:
	text_far WLA_GLOBAL_PokemonMansion3FScientistBattleText
	text_end

PokemonMansion3FScientistEndBattleText:
	text_far WLA_GLOBAL_PokemonMansion3FScientistEndBattleText
	text_end

PokemonMansion3FScientistAfterBattleText:
	text_far WLA_GLOBAL_PokemonMansion3FScientistAfterBattleText
	text_end

PokemonMansion3FDiaryText:
	text_far WLA_GLOBAL_PokemonMansion3FDiaryText
	text_end
