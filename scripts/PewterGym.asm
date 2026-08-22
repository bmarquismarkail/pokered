PewterGym_Script:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	call nz, PewterGym_Script.LoadNames
	call EnableAutoTextBoxDrawing
	ld hl, PewterGymTrainerHeaders
	ld de, PewterGym_ScriptPointers
	ld a, [wPewterGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPewterGymCurScript], a
	ret

PewterGym_Script.LoadNames:
	ld hl, PewterGym_Script.CityName
	ld de, PewterGym_Script.LeaderName
	jp LoadGymLeaderAndCityName

PewterGym_Script.CityName:
		.STRINGMAP pokemon, "PEWTER CITY@"

PewterGym_Script.LeaderName:
		.STRINGMAP pokemon, "BROCK@"

PewterGymResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
	ret

PewterGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_PEWTERGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_PEWTERGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_PEWTERGYM_END_BATTLE
	dw_const PewterGymBrockPostBattle,              SCRIPT_PEWTERGYM_BROCK_POST_BATTLE

PewterGymBrockPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PewterGymResetScripts
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
; fallthrough
PewterGymScriptReceiveTM34:
	ld a, TEXT_PEWTERGYM_BROCK_WAIT_TAKE_THIS
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	SetEvent EVENT_BEAT_BROCK
	lb "bc", TM_BIDE, 1
	call GiveItem
	jr nc, PewterGymScriptReceiveTM34.BagFull
	ld a, TEXT_PEWTERGYM_RECEIVED_TM34
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM34
	jr PewterGymScriptReceiveTM34.gymVictory
PewterGymScriptReceiveTM34.BagFull
	ld a, TEXT_PEWTERGYM_TM34_NO_ROOM
	ldh [lobyte(hTextID)], a
	call DisplayTextID
PewterGymScriptReceiveTM34.gymVictory
	ld hl, wObtainedBadges
	set BIT_BOULDERBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_BOULDERBADGE, [hl]

	ld a, TOGGLE_GYM_GUY
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_ROUTE_22_RIVAL_1
	ld [wToggleableObjectIndex], a
	predef HideObject

	ResetEvents EVENT_1ST_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE

	; deactivate gym trainers
	SetEvent EVENT_BEAT_PEWTER_GYM_TRAINER_0

	jp PewterGymResetScripts

PewterGym_TextPointers:
	def_text_pointers
	dw_const PewterGymBrockText,             TEXT_PEWTERGYM_BROCK
	dw_const PewterGymCooltrainerMText,      TEXT_PEWTERGYM_COOLTRAINER_M
	dw_const PewterGymGuideText,             TEXT_PEWTERGYM_GYM_GUIDE
	dw_const PewterGymBrockWaitTakeThisText, TEXT_PEWTERGYM_BROCK_WAIT_TAKE_THIS
	dw_const PewterGymReceivedTM34Text,      TEXT_PEWTERGYM_RECEIVED_TM34
	dw_const PewterGymTM34NoRoomText,        TEXT_PEWTERGYM_TM34_NO_ROOM

PewterGymTrainerHeaders:
	def_trainers 2
PewterGymTrainerHeader0:
	trainer EVENT_BEAT_PEWTER_GYM_TRAINER_0, 5, PewterGymCooltrainerMBattleText, PewterGymCooltrainerMEndBattleText, PewterGymCooltrainerMAfterBattleText
	.DB -1 ; end

PewterGymBrockText:
	text_asm
	CheckEvent EVENT_BEAT_BROCK
	jr z, PewterGymBrockText.beforeBeat
	CheckEventReuseA EVENT_GOT_TM34
	jr nz, PewterGymBrockText.afterBeat
	call z, PewterGymScriptReceiveTM34
	call DisableWaitingAfterTextDisplay
	jr PewterGymBrockText.done
PewterGymBrockText.afterBeat
	ld hl, PewterGymBrockText.PostBattleAdviceText
	call PrintText
	jr PewterGymBrockText.done
PewterGymBrockText.beforeBeat
	ld hl, PewterGymBrockText.PreBattleText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, PewterGymBrockReceivedBoulderBadgeText
	ld de, PewterGymBrockReceivedBoulderBadgeText
	call SaveEndBattleTextPointers
	ldh a, [lobyte(hSpriteIndex)]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $1
	ld [wGymLeaderNo], a
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld a, SCRIPT_PEWTERGYM_BROCK_POST_BATTLE
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
PewterGymBrockText.done
	jp TextScriptEnd

PewterGymBrockText.PreBattleText:
	text_far WLA_GLOBAL_PewterGymBrockPreBattleText
	text_end

PewterGymBrockText.PostBattleAdviceText:
	text_far WLA_GLOBAL_PewterGymBrockPostBattleAdviceText
	text_end

PewterGymBrockWaitTakeThisText:
	text_far WLA_GLOBAL_PewterGymBrockWaitTakeThisText
	text_end

PewterGymReceivedTM34Text:
	text_far WLA_GLOBAL_PewterGymReceivedTM34Text
	sound_get_item_1
	text_far WLA_GLOBAL_TM34ExplanationText
	text_end

PewterGymTM34NoRoomText:
	text_far WLA_GLOBAL_PewterGymTM34NoRoomText
	text_end

PewterGymBrockReceivedBoulderBadgeText:
	text_far WLA_GLOBAL_PewterGymBrockReceivedBoulderBadgeText
	sound_level_up ; probably supposed to play SFX_GET_ITEM_1 but the wrong music bank is loaded
	text_far WLA_GLOBAL_PewterGymBrockBoulderBadgeInfoText ; Text to tell that the flash technique can be used
	text_end

PewterGymCooltrainerMText:
	text_asm
	ld hl, PewterGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PewterGymCooltrainerMBattleText:
	text_far WLA_GLOBAL_PewterGymCooltrainerMBattleText
	text_end

PewterGymCooltrainerMEndBattleText:
	text_far WLA_GLOBAL_PewterGymCooltrainerMEndBattleText
	text_end

PewterGymCooltrainerMAfterBattleText:
	text_far WLA_GLOBAL_PewterGymCooltrainerMAfterBattleText
	text_end

PewterGymGuideText:
	text_asm
	ld a, [wBeatGymFlags]
	bit BIT_BOULDERBADGE, a
	jr nz, PewterGymGuideText.afterBeat
	ld hl, PewterGymGuidePreAdviceText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, PewterGymGuideText.PewterGymGuideBeginAdviceText
	ld hl, PewterGymGuideBeginAdviceText
	call PrintText
	jr PewterGymGuideText.PewterGymGuideAdviceText
PewterGymGuideText.PewterGymGuideBeginAdviceText
	ld hl, PewterGymGuideFreeServiceText
	call PrintText
PewterGymGuideText.PewterGymGuideAdviceText
	ld hl, PewterGymGuideAdviceText
	call PrintText
	jr PewterGymGuideText.done
PewterGymGuideText.afterBeat
	ld hl, PewterGymGuidePostBattleText
	call PrintText
PewterGymGuideText.done
	jp TextScriptEnd

PewterGymGuidePreAdviceText:
	text_far WLA_GLOBAL_PewterGymGuidePreAdviceText
	text_end

PewterGymGuideBeginAdviceText:
	text_far WLA_GLOBAL_PewterGymGuideBeginAdviceText
	text_end

PewterGymGuideAdviceText:
	text_far WLA_GLOBAL_PewterGymGuideAdviceText
	text_end

PewterGymGuideFreeServiceText:
	text_far WLA_GLOBAL_PewterGymGuideFreeServiceText
	text_end

PewterGymGuidePostBattleText:
	text_far WLA_GLOBAL_PewterGymGuidePostBattleText
	text_end
