CeruleanGym_Script:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	call nz, CeruleanGym_Script.LoadNames
	call EnableAutoTextBoxDrawing
	ld hl, CeruleanGymTrainerHeaders
	ld de, CeruleanGym_ScriptPointers
	ld a, [wCeruleanGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wCeruleanGymCurScript], a
	ret

CeruleanGym_Script.LoadNames:
	ld hl, CeruleanGym_Script.CityName
	ld de, CeruleanGym_Script.LeaderName
	jp LoadGymLeaderAndCityName

CeruleanGym_Script.CityName:
		.STRINGMAP pokemon, "CERULEAN CITY@"

CeruleanGym_Script.LeaderName:
		.STRINGMAP pokemon, "MISTY@"

CeruleanGymResetScripts:
	xor a ; SCRIPT_CERULEANGYM_DEFAULT
	ld [wJoyIgnore], a
	ld [wCeruleanGymCurScript], a
	ld [wCurMapScript], a
	ret

CeruleanGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_CERULEANGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_CERULEANGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_CERULEANGYM_END_BATTLE
	dw_const CeruleanGymMistyPostBattleScript,      SCRIPT_CERULEANGYM_MISTY_POST_BATTLE

CeruleanGymMistyPostBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CeruleanGymResetScripts
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a

CeruleanGymReceiveTM11:
	ld a, TEXT_CERULEANGYM_MISTY_CASCADE_BADGE_INFO
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	SetEvent EVENT_BEAT_MISTY
	lb "bc", TM_BUBBLEBEAM, 1
	call GiveItem
	jr nc, CeruleanGymReceiveTM11.BagFull
	ld a, TEXT_CERULEANGYM_MISTY_RECEIVED_TM11
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM11
	jr CeruleanGymReceiveTM11.gymVictory
CeruleanGymReceiveTM11.BagFull
	ld a, TEXT_CERULEANGYM_MISTY_TM11_NO_ROOM
	ldh [lobyte(hTextID)], a
	call DisplayTextID
CeruleanGymReceiveTM11.gymVictory
	ld hl, wObtainedBadges
	set BIT_CASCADEBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_CASCADEBADGE, [hl]

	; deactivate gym trainers
	SetEvents EVENT_BEAT_CERULEAN_GYM_TRAINER_0, EVENT_BEAT_CERULEAN_GYM_TRAINER_1

	jp CeruleanGymResetScripts

CeruleanGym_TextPointers:
	def_text_pointers
	dw_const CeruleanGymMistyText,                 TEXT_CERULEANGYM_MISTY
	dw_const CeruleanGymCooltrainerFText,          TEXT_CERULEANGYM_COOLTRAINER_F
	dw_const CeruleanGymSwimmerText,               TEXT_CERULEANGYM_SWIMMER
	dw_const CeruleanGymGymGuideText,              TEXT_CERULEANGYM_GYM_GUIDE
	dw_const CeruleanGymMistyCascadeBadgeInfoText, TEXT_CERULEANGYM_MISTY_CASCADE_BADGE_INFO
	dw_const CeruleanGymMistyReceivedTM11Text,     TEXT_CERULEANGYM_MISTY_RECEIVED_TM11
	dw_const CeruleanGymMistyTM11NoRoomText,       TEXT_CERULEANGYM_MISTY_TM11_NO_ROOM

CeruleanGymTrainerHeaders:
	def_trainers 2
CeruleanGymTrainerHeader0:
	trainer EVENT_BEAT_CERULEAN_GYM_TRAINER_0, 3, CeruleanGymBattleText1, CeruleanGymEndBattleText1, CeruleanGymAfterBattleText1
CeruleanGymTrainerHeader1:
	trainer EVENT_BEAT_CERULEAN_GYM_TRAINER_1, 3, CeruleanGymBattleText2, CeruleanGymEndBattleText2, CeruleanGymAfterBattleText2
	.DB -1 ; end

CeruleanGymMistyText:
	text_asm
	CheckEvent EVENT_BEAT_MISTY
	jr z, CeruleanGymMistyText.beforeBeat
	CheckEventReuseA EVENT_GOT_TM11
	jr nz, CeruleanGymMistyText.afterBeat
	call z, CeruleanGymReceiveTM11
	call DisableWaitingAfterTextDisplay
	jr CeruleanGymMistyText.done
CeruleanGymMistyText.afterBeat
	ld hl, CeruleanGymMistyText.TM11ExplanationText
	call PrintText
	jr CeruleanGymMistyText.done
CeruleanGymMistyText.beforeBeat
	ld hl, CeruleanGymMistyText.PreBattleText
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, CeruleanGymMistyReceivedCascadeBadgeText
	ld de, CeruleanGymMistyReceivedCascadeBadgeText
	call SaveEndBattleTextPointers
	ldh a, [lobyte(hSpriteIndex)]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $2
	ld [wGymLeaderNo], a
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld a, SCRIPT_CERULEANGYM_MISTY_POST_BATTLE
	ld [wCeruleanGymCurScript], a
CeruleanGymMistyText.done
	jp TextScriptEnd

CeruleanGymMistyText.PreBattleText:
	text_far WLA_GLOBAL_CeruleanGymMistyPreBattleText
	text_end

CeruleanGymMistyText.TM11ExplanationText:
	text_far WLA_GLOBAL_CeruleanGymMistyTM11ExplanationText
	text_end

CeruleanGymMistyCascadeBadgeInfoText:
	text_far WLA_GLOBAL_CeruleanGymMistyCascadeBadgeInfoText
	text_end

CeruleanGymMistyReceivedTM11Text:
	text_far WLA_GLOBAL_CeruleanGymMistyReceivedTM11Text
	sound_get_item_1
	text_end

CeruleanGymMistyTM11NoRoomText:
	text_far WLA_GLOBAL_CeruleanGymMistyTM11NoRoomText
	text_end

CeruleanGymMistyReceivedCascadeBadgeText:
	text_far WLA_GLOBAL_CeruleanGymMistyReceivedCascadeBadgeText
	sound_get_key_item ; actually plays the second channel of SFX_BALL_POOF due to the wrong music bank being loaded
	text_promptbutton
	text_end

CeruleanGymCooltrainerFText:
	text_asm
	ld hl, CeruleanGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

CeruleanGymBattleText1:
	text_far WLA_GLOBAL_CeruleanGymBattleText1
	text_end

CeruleanGymEndBattleText1:
	text_far WLA_GLOBAL_CeruleanGymEndBattleText1
	text_end

CeruleanGymAfterBattleText1:
	text_far WLA_GLOBAL_CeruleanGymAfterBattleText1
	text_end

CeruleanGymSwimmerText:
	text_asm
	ld hl, CeruleanGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

CeruleanGymBattleText2:
	text_far WLA_GLOBAL_CeruleanGymBattleText2
	text_end

CeruleanGymEndBattleText2:
	text_far WLA_GLOBAL_CeruleanGymEndBattleText2
	text_end

CeruleanGymAfterBattleText2:
	text_far WLA_GLOBAL_CeruleanGymAfterBattleText2
	text_end

CeruleanGymGymGuideText:
	text_asm
	CheckEvent EVENT_BEAT_MISTY
	jr nz, CeruleanGymGymGuideText.afterBeat
	ld hl, CeruleanGymGymGuideText.ChampInMakingText
	call PrintText
	jr CeruleanGymGymGuideText.done
CeruleanGymGymGuideText.afterBeat
	ld hl, CeruleanGymGymGuideText.BeatMistyText
	call PrintText
CeruleanGymGymGuideText.done
	jp TextScriptEnd

CeruleanGymGymGuideText.ChampInMakingText:
	text_far WLA_GLOBAL_CeruleanGymGymGuideChampInMakingText
	text_end

CeruleanGymGymGuideText.BeatMistyText:
	text_far WLA_GLOBAL_CeruleanGymGymGuideBeatMistyText
	text_end
