SilphCo8F_Script:
	call SilphCo8FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo8TrainerHeaders
	ld de, SilphCo8F_ScriptPointers
	ld a, [wSilphCo8FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo8FCurScript], a
	ret

SilphCo8FGateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	ld hl, SilphCo8FGateCallbackScript.GateCoordinates
	call SilphCo8F_SetCardKeyDoorYScript
	call SilphCo8F_UnlockedDoorEventScript
	CheckEvent EVENT_SILPH_CO_8_UNLOCKED_DOOR
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb "bc", 4, 3
	predef_jump ReplaceTileBlock

SilphCo8FGateCallbackScript.GateCoordinates:
	dbmapcoord  3,  4
	.DB -1 ; end

SilphCo8F_SetCardKeyDoorYScript:
	push hl
	ld hl, wCardKeyDoorY
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	xor a
	ldh [lobyte(hUnlockedSilphCoDoors)], a
	pop hl
SilphCo8F_SetCardKeyDoorYScript.loop_check_doors
	ld a, [hli]
	cp $ff
	jr z, SilphCo8F_SetCardKeyDoorYScript.exit_loop
	push hl
	ld hl, hUnlockedSilphCoDoors
	inc [hl]
	pop hl
	cp b
	jr z, SilphCo8F_SetCardKeyDoorYScript.check_y_coord
	inc hl
	jr SilphCo8F_SetCardKeyDoorYScript.loop_check_doors
SilphCo8F_SetCardKeyDoorYScript.check_y_coord
	ld a, [hli]
	cp c
	jr nz, SilphCo8F_SetCardKeyDoorYScript.loop_check_doors
	ld hl, wCardKeyDoorY
	xor a
	ld [hli], a
	ld [hl], a
	ret
SilphCo8F_SetCardKeyDoorYScript.exit_loop
	xor a
	ldh [lobyte(hUnlockedSilphCoDoors)], a
	ret

SilphCo8F_UnlockedDoorEventScript:
	ldh a, [lobyte(hUnlockedSilphCoDoors)]
	and a
	ret z
	SetEvent EVENT_SILPH_CO_8_UNLOCKED_DOOR
	ret

SilphCo8F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO8F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO8F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO8F_END_BATTLE

SilphCo8F_TextPointers:
	def_text_pointers
	dw_const SilphCo8FSilphWorkerMText, TEXT_SILPHCO8F_SILPH_WORKER_M
	dw_const SilphCo8FRocket1Text,      TEXT_SILPHCO8F_ROCKET1
	dw_const SilphCo8FScientistText,    TEXT_SILPHCO8F_SCIENTIST
	dw_const SilphCo8FRocket2Text,      TEXT_SILPHCO8F_ROCKET2

SilphCo8TrainerHeaders:
	def_trainers 2
SilphCo8TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_0, 4, SilphCo8FRocket1BattleText, SilphCo8FRocket1EndBattleText, SilphCo8FRocket1AfterBattleText
SilphCo8TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_1, 4, SilphCo8FScientistBattleText, SilphCo8FScientistEndBattleText, SilphCo8FScientistAfterBattleText
SilphCo8TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_8F_TRAINER_2, 4, SilphCo8FRocket2BattleText, SilphCo8FRocket2EndBattleText, SilphCo8FRocket2AfterBattleText
	.DB -1 ; end

SilphCo8FSilphWorkerMText:
	text_asm
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, SilphCo8FSilphWorkerMText.ThanksForSavingUsText
	jr nz, SilphCo8FSilphWorkerMText.beat_giovanni
	ld hl, SilphCo8FSilphWorkerMText.SilphIsFinishedText
SilphCo8FSilphWorkerMText.beat_giovanni
	call PrintText
	jp TextScriptEnd

SilphCo8FSilphWorkerMText.SilphIsFinishedText:
	text_far WLA_GLOBAL_SilphCo8FSilphWorkerMSilphIsFinishedText
	text_end

SilphCo8FSilphWorkerMText.ThanksForSavingUsText:
	text_far WLA_GLOBAL_SilphCo8FSilphWorkerMThanksForSavingUsText
	text_end

SilphCo8FRocket1Text:
	text_asm
	ld hl, SilphCo8TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo8FScientistText:
	text_asm
	ld hl, SilphCo8TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo8FRocket2Text:
	text_asm
	ld hl, SilphCo8TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo8FRocket1BattleText:
	text_far WLA_GLOBAL_SilphCo8FRocket1BattleText
	text_end

SilphCo8FRocket1EndBattleText:
	text_far WLA_GLOBAL_SilphCo8FRocket1EndBattleText
	text_end

SilphCo8FRocket1AfterBattleText:
	text_far WLA_GLOBAL_SilphCo8FRocket1AfterBattleText
	text_end

SilphCo8FScientistBattleText:
	text_far WLA_GLOBAL_SilphCo8FScientistBattleText
	text_end

SilphCo8FScientistEndBattleText:
	text_far WLA_GLOBAL_SilphCo8FScientistEndBattleText
	text_end

SilphCo8FScientistAfterBattleText:
	text_far WLA_GLOBAL_SilphCo8FScientistAfterBattleText
	text_end

SilphCo8FRocket2BattleText:
	text_far WLA_GLOBAL_SilphCo8FRocket2BattleText
	text_end

SilphCo8FRocket2EndBattleText:
	text_far WLA_GLOBAL_SilphCo8FRocket2EndBattleText
	text_end

SilphCo8FRocket2AfterBattleText:
	text_far WLA_GLOBAL_SilphCo8FRocket2AfterBattleText
	text_end
