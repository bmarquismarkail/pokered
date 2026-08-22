SilphCo2F_Script:
	call SilphCo2FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo2TrainerHeaders
	ld de, SilphCo2F_ScriptPointers
	ld a, [wSilphCo2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo2FCurScript], a
	ret

SilphCo2FGateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	ld hl, SilphCo2FGateCallbackScript.GateCoordinates
	call SilphCo2F_SetCardKeyDoorYScript
	call SilphCo2F_UnlockedDoorEventScript
	CheckEvent EVENT_SILPH_CO_2_UNLOCKED_DOOR1
	jr nz, SilphCo2FGateCallbackScript.unlock_door1
	push af
	ld a, $54
	ld [wNewTileBlockID], a
	lb "bc", 2, 2
	predef ReplaceTileBlock
	pop af
SilphCo2FGateCallbackScript.unlock_door1
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_2_UNLOCKED_DOOR2, EVENT_SILPH_CO_2_UNLOCKED_DOOR1
	ret nz
	ld a, $54
	ld [wNewTileBlockID], a
	lb "bc", 5, 2
	predef_jump ReplaceTileBlock

SilphCo2FGateCallbackScript.GateCoordinates:
	dbmapcoord  2,  2
	dbmapcoord  2,  5
	.DB -1 ; end

SilphCo2F_SetCardKeyDoorYScript:
	push hl
	ld hl, wCardKeyDoorY
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	xor a
	ldh [lobyte(hUnlockedSilphCoDoors)], a
	pop hl
SilphCo2F_SetCardKeyDoorYScript.loop_check_doors
	ld a, [hli]
	cp $ff
	jr z, SilphCo2F_SetCardKeyDoorYScript.exit_loop
	push hl
	ld hl, hUnlockedSilphCoDoors
	inc [hl]
	pop hl
	cp b
	jr z, SilphCo2F_SetCardKeyDoorYScript.check_y_coord
	inc hl
	jr SilphCo2F_SetCardKeyDoorYScript.loop_check_doors
SilphCo2F_SetCardKeyDoorYScript.check_y_coord
	ld a, [hli]
	cp c
	jr nz, SilphCo2F_SetCardKeyDoorYScript.loop_check_doors
	ld hl, wCardKeyDoorY
	xor a
	ld [hli], a
	ld [hl], a
	ret
SilphCo2F_SetCardKeyDoorYScript.exit_loop
	xor a
	ldh [lobyte(hUnlockedSilphCoDoors)], a
	ret

SilphCo2F_UnlockedDoorEventScript:
	EventFlagAddress "hl", EVENT_SILPH_CO_2_UNLOCKED_DOOR1
	ldh a, [lobyte(hUnlockedSilphCoDoors)]
	and a
	ret z
	cp $1
	jr nz, SilphCo2F_UnlockedDoorEventScript.unlock_door1
	SetEventReuseHL EVENT_SILPH_CO_2_UNLOCKED_DOOR1
	ret
SilphCo2F_UnlockedDoorEventScript.unlock_door1
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_2_UNLOCKED_DOOR2, EVENT_SILPH_CO_2_UNLOCKED_DOOR1
	ret

SilphCo2F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO2F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO2F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO2F_END_BATTLE

SilphCo2F_TextPointers:
	def_text_pointers
	dw_const SilphCo2FSilphWorkerFText, TEXT_SILPHCO2F_SILPH_WORKER_F
	dw_const SilphCo2FScientist1Text,   TEXT_SILPHCO2F_SCIENTIST1
	dw_const SilphCo2FScientist2Text,   TEXT_SILPHCO2F_SCIENTIST2
	dw_const SilphCo2FRocket1Text,      TEXT_SILPHCO2F_ROCKET1
	dw_const SilphCo2FRocket2Text,      TEXT_SILPHCO2F_ROCKET2

SilphCo2TrainerHeaders:
	def_trainers 2
SilphCo2TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_2F_TRAINER_0, 3, SilphCo2FScientist1BattleText, SilphCo2FScientist1EndBattleText, SilphCo2FScientist1AfterBattleText
SilphCo2TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_2F_TRAINER_1, 4, SilphCo2FScientist2BattleText, SilphCo2FScientist2EndBattleText, SilphCo2FScientist2AfterBattleText
SilphCo2TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_2F_TRAINER_2, 3, SilphCo2FRocket1BattleText, SilphCo2FRocket1EndBattleText, SilphCo2FRocket1AfterBattleText
SilphCo2TrainerHeader3:
	trainer EVENT_BEAT_SILPH_CO_2F_TRAINER_3, 3, SilphCo2FRocket2BattleText, SilphCo2FRocket2EndBattleText, SilphCo2FRocket2AfterBattleText
	.DB -1 ; end

SilphCo2FSilphWorkerFText:
	text_asm
	CheckEvent EVENT_GOT_TM36
	jr nz, SilphCo2FSilphWorkerFText.already_have_tm
	ld hl, SilphCo2FSilphWorkerFText.PleaseTakeThisText
	call PrintText
	lb "bc", TM_SELFDESTRUCT, 1
	call GiveItem
	ld hl, SilphCo2FSilphWorkerFText.TM36NoRoomText
	jr nc, SilphCo2FSilphWorkerFText.print_text
	SetEvent EVENT_GOT_TM36
	ld hl, SilphCo2FSilphWorkerFText.ReceivedTM36Text
	jr SilphCo2FSilphWorkerFText.print_text
SilphCo2FSilphWorkerFText.already_have_tm
	ld hl, SilphCo2FSilphWorkerFText.TM36ExplanationText
SilphCo2FSilphWorkerFText.print_text
	call PrintText
	jp TextScriptEnd

SilphCo2FSilphWorkerFText.PleaseTakeThisText:
	text_far SilphCo2FSilphWorkerFPleaseTakeThisText
	text_end

SilphCo2FSilphWorkerFText.ReceivedTM36Text:
	text_far WLA_GLOBAL_SilphCo2FSilphWorkerFReceivedTM36Text
	sound_get_item_1
	text_end

SilphCo2FSilphWorkerFText.TM36ExplanationText:
	text_far WLA_GLOBAL_SilphCo2FSilphWorkerFTM36ExplanationText
	text_end

SilphCo2FSilphWorkerFText.TM36NoRoomText:
	text_far WLA_GLOBAL_SilphCo2FSilphWorkerFTM36NoRoomText
	text_end

SilphCo2FScientist1Text:
	text_asm
	ld hl, SilphCo2TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo2FScientist2Text:
	text_asm
	ld hl, SilphCo2TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo2FRocket1Text:
	text_asm
	ld hl, SilphCo2TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo2FRocket2Text:
	text_asm
	ld hl, SilphCo2TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SilphCo2FScientist1BattleText:
	text_far WLA_GLOBAL_SilphCo2FScientist1BattleText
	text_end

SilphCo2FScientist1EndBattleText:
	text_far WLA_GLOBAL_SilphCo2FScientist1EndBattleText
	text_end

SilphCo2FScientist1AfterBattleText:
	text_far WLA_GLOBAL_SilphCo2FScientist1AfterBattleText
	text_end

SilphCo2FScientist2BattleText:
	text_far WLA_GLOBAL_SilphCo2FScientist2BattleText
	text_end

SilphCo2FScientist2EndBattleText:
	text_far WLA_GLOBAL_SilphCo2FScientist2EndBattleText
	text_end

SilphCo2FScientist2AfterBattleText:
	text_far WLA_GLOBAL_SilphCo2FScientist2AfterBattleText
	text_end

SilphCo2FRocket1BattleText:
	text_far WLA_GLOBAL_SilphCo2FRocket1BattleText
	text_end

SilphCo2FRocket1EndBattleText:
	text_far WLA_GLOBAL_SilphCo2FRocket1EndBattleText
	text_end

SilphCo2FRocket1AfterBattleText:
	text_far WLA_GLOBAL_SilphCo2FRocket1AfterBattleText
	text_end

SilphCo2FRocket2BattleText:
	text_far WLA_GLOBAL_SilphCo2FRocket2BattleText
	text_end

SilphCo2FRocket2EndBattleText:
	text_far WLA_GLOBAL_SilphCo2FRocket2EndBattleText
	text_end

SilphCo2FRocket2AfterBattleText:
	text_far WLA_GLOBAL_SilphCo2FRocket2AfterBattleText
	text_end
