SilphCo6F_Script:
	call SilphCo6F_GateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo6TrainerHeaders
	ld de, SilphCo6F_ScriptPointers
	ld a, [wSilphCo6FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo6FCurScript], a
	ret

SilphCo6F_GateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	ld hl, SilphCo6F_GateCallbackScript.GateCoordinates
	call SilphCo4F_SetCardKeyDoorYScript
	call SilphCo6F_UnlockedDoorEventScript
	CheckEvent EVENT_SILPH_CO_6_UNLOCKED_DOOR
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb "bc", 6, 2
	predef_jump ReplaceTileBlock

SilphCo6F_GateCallbackScript.GateCoordinates:
	dbmapcoord  2,  6
	.DB -1 ; end

SilphCo6F_UnlockedDoorEventScript:
	ldh a, [lobyte(hUnlockedSilphCoDoors)]
	and a
	ret z
	SetEvent EVENT_SILPH_CO_6_UNLOCKED_DOOR
	ret

SilphCo6F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SILPHCO6F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO6F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO6F_END_BATTLE

SilphCo6F_TextPointers:
	def_text_pointers
	dw_const SilphCo6FSilphWorkerM1Text, TEXT_SILPHCO6F_SILPH_WORKER_M1
	dw_const SilphCo6FSilphWorkerM2Text, TEXT_SILPHCO6F_SILPH_WORKER_M2
	dw_const SilphCo6FSilphWorkerF1Text, TEXT_SILPHCO6F_SILPH_WORKER_F1
	dw_const SilphCo6FSilphWorkerF2Text, TEXT_SILPHCO6F_SILPH_WORKER_F2
	dw_const SilphCo6FSilphWorkerM3Text, TEXT_SILPHCO6F_SILPH_WORKER_M3
	dw_const SilphCo6FRocket1Text,       TEXT_SILPHCO6F_ROCKET1
	dw_const SilphCo6FScientistText,     TEXT_SILPHCO6F_SCIENTIST
	dw_const SilphCo6FRocket2Text,       TEXT_SILPHCO6F_ROCKET2
	dw_const PickUpItemText,             TEXT_SILPHCO6F_HP_UP
	dw_const PickUpItemText,             TEXT_SILPHCO6F_X_ACCURACY

SilphCo6TrainerHeaders:
	def_trainers 6
SilphCo6TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_6F_TRAINER_0, 2, SilphCo6FRocket1BattleText, SilphCo6FRocket1EndBattleText, SilphCo6FRocket1AfterBattleText
SilphCo6TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_6F_TRAINER_1, 3, SilphCo6FScientistBattleText, SilphCo6FScientistEndBattleText, SilphCo6FScientistAfterBattleText
SilphCo6TrainerHeader2:
	trainer EVENT_BEAT_SILPH_CO_6F_TRAINER_2, 2, SilphCo6FRocket2BattleText, SilphCo6FRocket2EndBattleText, SilphCo6FRocket2AfterBattleText
	.DB -1 ; end

SilphCo6FBeatGiovanniPrintDEOrPrintHLScript:
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, SilphCo6FBeatGiovanniPrintDEOrPrintHLScript.beat_giovanni
	jr SilphCo6FBeatGiovanniPrintDEOrPrintHLScript.print_text
SilphCo6FBeatGiovanniPrintDEOrPrintHLScript.beat_giovanni
	ld h, d
	ld l, e
SilphCo6FBeatGiovanniPrintDEOrPrintHLScript.print_text
	jp PrintText

SilphCo6FSilphWorkerM1Text:
	text_asm
	ld hl, SilphCo6FSilphWorkerM1Text.TookOverTheBuildingText
	ld de, SilphCo6FSilphWorkerM1Text.BackToWorkText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	jp TextScriptEnd

SilphCo6FSilphWorkerM1Text.TookOverTheBuildingText:
	text_far WLA_GLOBAL_SilphCo6FSilphWorkerM1TookOverTheBuildingText
	text_end

SilphCo6FSilphWorkerM1Text.BackToWorkText:
	text_far WLA_GLOBAL_SilphCo6FSilphWorkerM1BackToWorkText
	text_end

SilphCo6FSilphWorkerM2Text:
	text_asm
	ld hl, SilphCo6FSilphWorkerM2Text.HelpMePleaseText
	ld de, SilphCo6FSilphWorkerM2Text.WeGotEngagedText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	jp TextScriptEnd

SilphCo6FSilphWorkerM2Text.HelpMePleaseText:
	text_far WLA_GLOBAL_SilphCo6FSilphWorkerMHelpMePleaseText
	text_end

SilphCo6FSilphWorkerM2Text.WeGotEngagedText:
	text_far WLA_GLOBAL_SilphCo6FSilphWorkerMWeGotEngagedText
	text_end

SilphCo6FSilphWorkerF1Text:
	text_asm
	ld hl, SilphCo6FSilphWorkerF1Text.SuchACowardText
	ld de, SilphCo6FSilphWorkerF1Text.HaveToMarryHimText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	jp TextScriptEnd

SilphCo6FSilphWorkerF1Text.SuchACowardText:
	text_far WLA_GLOBAL_SilphCo6FSilphWorkerF1SuchACowardText
	text_end

SilphCo6FSilphWorkerF1Text.HaveToMarryHimText:
	text_far WLA_GLOBAL_SilphCo6FSilphWorkerF1HaveToMarryHimText
	text_end

SilphCo6FSilphWorkerF2Text:
	text_asm
	ld hl, SilphCo6FSilphWorkerF2Text.TeamRocketConquerWorldText
	ld de, SilphCo6FSilphWorkerF2Text.TeamRocketRanText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	jp TextScriptEnd

SilphCo6FSilphWorkerF2Text.TeamRocketConquerWorldText:
	text_far WLA_GLOBAL_SilphCo6FSilphWorkerF2TeamRocketConquerWorldText
	text_end

SilphCo6FSilphWorkerF2Text.TeamRocketRanText:
	text_far WLA_GLOBAL_SilphCo6FSilphWorkerF2TeamRocketRanText
	text_end

SilphCo6FSilphWorkerM3Text:
	text_asm
	ld hl, SilphCo6FSilphWorkerM3Text.TargetedSilphText
	ld de, SilphCo6FSilphWorkerM3Text.WorkForSilphText
	call SilphCo6FBeatGiovanniPrintDEOrPrintHLScript
	jp TextScriptEnd

SilphCo6FSilphWorkerM3Text.TargetedSilphText:
	text_far WLA_GLOBAL_SilphCo6FSilphWorkerM3TargetedSilphText
	text_end

SilphCo6FSilphWorkerM3Text.WorkForSilphText:
	text_far WLA_GLOBAL_SilphCo6FSilphWorkerM3WorkForSilphText
	text_end

SilphCo6FRocket1Text:
	text_asm
	ld hl, SilphCo6TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo6FRocket1BattleText:
	text_far WLA_GLOBAL_SilphCo6FRocket1BattleText
	text_end

SilphCo6FRocket1EndBattleText:
	text_far WLA_GLOBAL_SilphCo6FRocket1EndBattleText
	text_end

SilphCo6FRocket1AfterBattleText:
	text_far WLA_GLOBAL_SilphCo6FRocket1AfterBattleText
	text_end

SilphCo6FScientistText:
	text_asm
	ld hl, SilphCo6TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo6FScientistBattleText:
	text_far WLA_GLOBAL_SilphCo6FScientistBattleText
	text_end

SilphCo6FScientistEndBattleText:
	text_far WLA_GLOBAL_SilphCo6FScientistEndBattleText
	text_end

SilphCo6FScientistAfterBattleText:
	text_far WLA_GLOBAL_SilphCo6FScientistAfterBattleText
	text_end

SilphCo6FRocket2Text:
	text_asm
	ld hl, SilphCo6TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo6FRocket2BattleText:
	text_far WLA_GLOBAL_SilphCo6FRocket2BattleText
	text_end

SilphCo6FRocket2EndBattleText:
	text_far WLA_GLOBAL_SilphCo6FRocket2EndBattleText
	text_end

SilphCo6FRocket2AfterBattleText:
	text_far WLA_GLOBAL_SilphCo6FRocket2AfterBattleText
	text_end
