SilphCo3F_Script:
	call SilphCo3FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo3TrainerHeaders
	ld de, SilphCo3F_ScriptPointers
	ld a, [wSilphCo3FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo3FCurScript], a
	ret

SilphCo3FGateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	ld hl, SilphCo3FGateCallbackScript.GateCoordinates
	call SilphCo2F_SetCardKeyDoorYScript
	call SilphCo3F_UnlockedDoorEventScript
	CheckEvent EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	jr nz, SilphCo3FGateCallbackScript.unlock_door1
	push af
	ld a, $5f
	ld [wNewTileBlockID], a
	lb "bc", 4, 4
	predef ReplaceTileBlock
	pop af
SilphCo3FGateCallbackScript.unlock_door1
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_3_UNLOCKED_DOOR2, EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb "bc", 4, 8
	predef_jump ReplaceTileBlock

SilphCo3FGateCallbackScript.GateCoordinates:
	dbmapcoord  4,  4
	dbmapcoord  8,  4
	.DB -1 ; end

SilphCo3F_UnlockedDoorEventScript:
	EventFlagAddress "hl", EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ldh a, [lobyte(hUnlockedSilphCoDoors)]
	and a
	ret z
	cp $1
	jr nz, SilphCo3F_UnlockedDoorEventScript.unlock_door1
	SetEventReuseHL EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ret
SilphCo3F_UnlockedDoorEventScript.unlock_door1
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_3_UNLOCKED_DOOR2, EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ret

SilphCo3F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO3F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO3F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO3F_END_BATTLE

SilphCo3F_TextPointers:
	def_text_pointers
	dw_const SilphCo3FSilphWorkerMText, TEXT_SILPHCO3F_SILPH_WORKER_M
	dw_const SilphCo3FRocketText,       TEXT_SILPHCO3F_ROCKET
	dw_const SilphCo3FScientistText,    TEXT_SILPHCO3F_SCIENTIST
	dw_const PickUpItemText,            TEXT_SILPHCO3F_HYPER_POTION

SilphCo3TrainerHeaders:
	def_trainers 2
SilphCo3TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_3F_TRAINER_0, 2, SilphCo3FRocketBattleText, SilphCo3FRocketEndBattleText, SilphCo3FRocketAfterBattleText
SilphCo3TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_3F_TRAINER_1, 3, SilphCo3FScientistBattleText, SilphCo3FScientistEndBattleText, SilphCo3FScientistAfterBattleText
	.DB -1 ; end

SilphCo3FSilphWorkerMText:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, SilphCo3FSilphWorkerMText.YouSavedUsText
	jr nz, SilphCo3FSilphWorkerMText.beat_giovanni
	ld hl, SilphCo3FSilphWorkerMText.WhatShouldIDoText
SilphCo3FSilphWorkerMText.beat_giovanni
	call PrintText
	jp TextScriptEnd

SilphCo3FSilphWorkerMText.WhatShouldIDoText:
	text_far WLA_GLOBAL_SilphCo3FSilphWorkerMWhatShouldIDoText
	text_end

SilphCo3FSilphWorkerMText.YouSavedUsText:
	text_far WLA_GLOBAL_SilphCo3FSilphWorkerMYouSavedUsText
	text_end

SilphCo3FRocketText:
	text_asm
	ld hl, SilphCo3TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo3FRocketBattleText:
	text_far WLA_GLOBAL_SilphCo3FRocketBattleText
	text_end

SilphCo3FRocketEndBattleText:
	text_far WLA_GLOBAL_SilphCo3FRocketEndBattleText
	text_end

SilphCo3FRocketAfterBattleText:
	text_far WLA_GLOBAL_SilphCo3FRocketAfterBattleText
	text_end

SilphCo3FScientistText:
	text_asm
	ld hl, SilphCo3TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo3FScientistBattleText:
	text_far WLA_GLOBAL_SilphCo3FScientistBattleText
	text_end

SilphCo3FScientistEndBattleText:
	text_far WLA_GLOBAL_SilphCo3FScientistEndBattleText
	text_end

SilphCo3FScientistAfterBattleText:
	text_far WLA_GLOBAL_SilphCo3FScientistAfterBattleText
	text_end
