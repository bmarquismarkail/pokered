SilphCo5F_Script:
	call SilphCo5FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo5TrainerHeaders
	ld de, SilphCo5F_ScriptPointers
	ld a, [wSilphCo5FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo5FCurScript], a
	ret

SilphCo5FGateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	ld hl, SilphCo5FGateCallbackScript.GateCoordinates
	call SilphCo4F_SetCardKeyDoorYScript
	call SilphCo5F_SetUnlockedSilphCoDoorsScript
	CheckEvent EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	jr nz, SilphCo5FGateCallbackScript.unlock_door1
	push af
	ld a, $5f
	ld [wNewTileBlockID], a
	lb "bc", 2, 3
	predef ReplaceTileBlock
	pop af
SilphCo5FGateCallbackScript.unlock_door1
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_5_UNLOCKED_DOOR2, EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	jr nz, SilphCo5FGateCallbackScript.unlock_door2
	push af
	ld a, $5f
	ld [wNewTileBlockID], a
	lb "bc", 6, 3
	predef ReplaceTileBlock
	pop af
SilphCo5FGateCallbackScript.unlock_door2
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_5_UNLOCKED_DOOR3, EVENT_SILPH_CO_5_UNLOCKED_DOOR2
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb "bc", 5, 7
	predef_jump ReplaceTileBlock

SilphCo5FGateCallbackScript.GateCoordinates:
	dbmapcoord  3,  2
	dbmapcoord  3,  6
	dbmapcoord  7,  5
	.DB -1 ; end

SilphCo5F_SetUnlockedSilphCoDoorsScript:
	EventFlagAddress "hl", EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ldh a, [lobyte(hUnlockedSilphCoDoors)]
	and a
	ret z
	cp $1
	jr nz, SilphCo5F_SetUnlockedSilphCoDoorsScript.unlock_door1
	SetEventReuseHL EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ret
SilphCo5F_SetUnlockedSilphCoDoorsScript.unlock_door1
	cp $2
	jr nz, SilphCo5F_SetUnlockedSilphCoDoorsScript.unlock_door2
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_5_UNLOCKED_DOOR2, EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ret
SilphCo5F_SetUnlockedSilphCoDoorsScript.unlock_door2
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_5_UNLOCKED_DOOR3, EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ret

SilphCo5F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO5F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO5F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO5F_END_BATTLE

SilphCo5F_TextPointers:
	def_text_pointers
	dw_const SilphCo5FSilphWorkerMText,   TEXT_SILPHCO5F_SILPH_WORKER_M
	dw_const SilphCo5FRocket1Text,        TEXT_SILPHCO5F_ROCKET1
	dw_const SilphCo5FScientistText,      TEXT_SILPHCO5F_SCIENTIST
	dw_const SilphCo5FRockerText,         TEXT_SILPHCO5F_ROCKER
	dw_const SilphCo5FRocket2Text,        TEXT_SILPHCO5F_ROCKET2
	dw_const PickUpItemText,              TEXT_SILPHCO5F_TM_TAKE_DOWN
	dw_const PickUpItemText,              TEXT_SILPHCO5F_PROTEIN
	dw_const PickUpItemText,              TEXT_SILPHCO5F_CARD_KEY
	dw_const SilphCo5FPokemonReport1Text, TEXT_SILPHCO5F_POKEMON_REPORT1
	dw_const SilphCo5FPokemonReport2Text, TEXT_SILPHCO5F_POKEMON_REPORT2
	dw_const SilphCo5FPokemonReport3Text, TEXT_SILPHCO5F_POKEMON_REPORT3

SilphCo5TrainerHeaders:
	def_trainers 2
SilphCo5TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_0, 1, SilphCo5FRocket1BattleText, SilphCo5FRocket1EndBattleText, SilphCo5FRocket1AfterBattleText
SilphCo5TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_1, 2, SilphCo5FScientistBattleText, SilphCo5FScientistEndBattleText, SilphCo5FScientistAfterBattleText
SilphCo5TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_2, 4, SilphCo5FRockerBattleText, SilphCo5FRockerEndBattleText, SilphCo5FRockerAfterBattleText
SilphCo5TrainerHeader3:
	trainer EVENT_BEAT_SILPH_CO_5F_TRAINER_3, 3, SilphCo5FRocket2BattleText, SilphCo5FRocket2EndBattleText, SilphCo5FRocket2AfterBattleText
	.DB -1 ; end

SilphCo5FSilphWorkerMText:
	text_asm
	ld hl, SilphCo5FSilphWorkerMText.ThatsYouRightText
	ld de, SilphCo5FSilphWorkerMText.YoureOurHeroText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	jp TextScriptEnd

SilphCo5FSilphWorkerMText.ThatsYouRightText:
	text_far WLA_GLOBAL_SilphCo5FSilphWorkerMThatsYouRightText
	text_end

SilphCo5FSilphWorkerMText.YoureOurHeroText:
	text_far WLA_GLOBAL_SilphCo5FSilphWorkerMYoureOurHeroText
	text_end

SilphCo5FRocket1Text:
	text_asm
	ld hl, SilphCo5TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5FRocket1BattleText:
	text_far WLA_GLOBAL_SilphCo5FRocket1BattleText
	text_end

SilphCo5FRocket1EndBattleText:
	text_far WLA_GLOBAL_SilphCo5FRocket1EndBattleText
	text_end

SilphCo5FRocket1AfterBattleText:
	text_far WLA_GLOBAL_SilphCo5FRocket1AfterBattleText
	text_end

SilphCo5FScientistText:
	text_asm
	ld hl, SilphCo5TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5FScientistBattleText:
	text_far WLA_GLOBAL_SilphCo5FScientistBattleText
	text_end

SilphCo5FScientistEndBattleText:
	text_far WLA_GLOBAL_SilphCo5FScientistEndBattleText
	text_end

SilphCo5FScientistAfterBattleText:
	text_far WLA_GLOBAL_SilphCo5FScientistAfterBattleText
	text_end

SilphCo5FRockerText:
	text_asm
	ld hl, SilphCo5TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5FRockerBattleText:
	text_far WLA_GLOBAL_SilphCo5FRockerBattleText
	text_end

SilphCo5FRockerEndBattleText:
	text_far WLA_GLOBAL_SilphCo5FRockerEndBattleText
	text_end

SilphCo5FRockerAfterBattleText:
	text_far WLA_GLOBAL_SilphCo5FRockerAfterBattleText
	text_end

SilphCo5FRocket2Text:
	text_asm
	ld hl, SilphCo5TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5FRocket2BattleText:
	text_far WLA_GLOBAL_SilphCo5FRocket2BattleText
	text_end

SilphCo5FRocket2EndBattleText:
	text_far WLA_GLOBAL_SilphCo5FRocket2EndBattleText
	text_end

SilphCo5FRocket2AfterBattleText:
	text_far WLA_GLOBAL_SilphCo5FRocket2AfterBattleText
	text_end

SilphCo5FPokemonReport1Text:
	text_far WLA_GLOBAL_SilphCo5FPokemonReport1Text
	text_end

SilphCo5FPokemonReport2Text:
	text_far WLA_GLOBAL_SilphCo5FPokemonReport2Text
	text_end

SilphCo5FPokemonReport3Text:
	text_far WLA_GLOBAL_SilphCo5FPokemonReport3Text
	text_end
