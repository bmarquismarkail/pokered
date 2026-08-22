SaffronGym_Script:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	call nz, SaffronGym_Script.LoadNames
	call EnableAutoTextBoxDrawing
	ld hl, SaffronGymTrainerHeaders
	ld de, SaffronGym_ScriptPointers
	ld a, [wSaffronGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSaffronGymCurScript], a
	ret

SaffronGym_Script.LoadNames:
	ld hl, SaffronGym_Script.CityName
	ld de, SaffronGym_Script.LeaderName
	jp LoadGymLeaderAndCityName

SaffronGym_Script.CityName:
		.STRINGMAP pokemon, "SAFFRON CITY@"

SaffronGym_Script.LeaderName:
		.STRINGMAP pokemon, "SABRINA@"

SaffronGymResetScripts:
	xor a ; SCRIPT_SAFFRONGYM_DEFAULT
	ld [wJoyIgnore], a
	ld [wSaffronGymCurScript], a
	ld [wCurMapScript], a
	ret

SaffronGym_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_SAFFRONGYM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SAFFRONGYM_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SAFFRONGYM_END_BATTLE
	dw_const SaffronGymSabrinaPostBattle,           SCRIPT_SAFFRONGYM_SABRINA_POST_BATTLE

SaffronGymSabrinaPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, SaffronGymResetScripts
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a

SaffronGymSabrinaReceiveTM46Script:
	ld a, TEXT_SAFFRONGYM_SABRINA_MARSH_BADGE_INFO
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	SetEvent EVENT_BEAT_SABRINA
	lb "bc", TM_PSYWAVE, 1
	call GiveItem
	jr nc, SaffronGymSabrinaReceiveTM46Script.BagFull
	ld a, TEXT_SAFFRONGYM_SABRINA_RECEIVED_TM46
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM46
	jr SaffronGymSabrinaReceiveTM46Script.gymVictory
SaffronGymSabrinaReceiveTM46Script.BagFull
	ld a, TEXT_SAFFRONGYM_SABRINA_TM46_NO_ROOM
	ldh [lobyte(hTextID)], a
	call DisplayTextID
SaffronGymSabrinaReceiveTM46Script.gymVictory
	ld hl, wObtainedBadges
	set BIT_MARSHBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_MARSHBADGE, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_SAFFRON_GYM_TRAINER_0, EVENT_BEAT_SAFFRON_GYM_TRAINER_6

	jp SaffronGymResetScripts

SaffronGym_TextPointers:
	def_text_pointers
	dw_const SaffronGymSabrinaText,               TEXT_SAFFRONGYM_SABRINA
	dw_const SaffronGymChanneler1Text,            TEXT_SAFFRONGYM_CHANNELER1
	dw_const SaffronGymYoungster1Text,            TEXT_SAFFRONGYM_YOUNGSTER1
	dw_const SaffronGymChanneler2Text,            TEXT_SAFFRONGYM_CHANNELER2
	dw_const SaffronGymYoungster2Text,            TEXT_SAFFRONGYM_YOUNGSTER2
	dw_const SaffronGymChanneler3Text,            TEXT_SAFFRONGYM_CHANNELER3
	dw_const SaffronGymYoungster3Text,            TEXT_SAFFRONGYM_YOUNGSTER3
	dw_const SaffronGymYoungster4Text,            TEXT_SAFFRONGYM_YOUNGSTER4
	dw_const SaffronGymGymGuideText,              TEXT_SAFFRONGYM_GYM_GUIDE
	dw_const SaffronGymSabrinaMarshBadgeInfoText, TEXT_SAFFRONGYM_SABRINA_MARSH_BADGE_INFO
	dw_const SaffronGymSabrinaReceivedTM46Text,   TEXT_SAFFRONGYM_SABRINA_RECEIVED_TM46
	dw_const SaffronGymSabrinaTM46NoRoomText,     TEXT_SAFFRONGYM_SABRINA_TM46_NO_ROOM

SaffronGymTrainerHeaders:
	def_trainers 2
SaffronGymTrainerHeader0:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_0, 3, SaffronGymChanneler1BattleText, SaffronGymChanneler1EndBattleText, SaffronGymChanneler1AfterBattleText
SaffronGymTrainerHeader1:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_1, 3, SaffronGymYoungster1BattleText, SaffronGymYoungster1EndBattleText, SaffronGymYoungster1AfterBattleText
SaffronGymTrainerHeader2:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_2, 3, SaffronGymChanneler2BattleText, SaffronGymChanneler2EndBattleText, SaffronGymChanneler2AfterBattleText
SaffronGymTrainerHeader3:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_3, 3, SaffronGymYoungster2BattleText, SaffronGymYoungster2EndBattleText, SaffronGymYoungster2AfterBattleText
SaffronGymTrainerHeader4:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_4, 3, SaffronGymChanneler3BattleText, SaffronGymChanneler3EndBattleText, SaffronGymChanneler3AfterBattleText
SaffronGymTrainerHeader5:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_5, 3, SaffronGymYoungster3BattleText, SaffronGymYoungster3EndBattleText, SaffronGymYoungster3AfterBattleText
SaffronGymTrainerHeader6:
	trainer EVENT_BEAT_SAFFRON_GYM_TRAINER_6, 3, SaffronGymYoungster4BattleText, SaffronGymYoungster4EndBattleText, SaffronGymYoungster4AfterBattleText
	.DB -1 ; end

SaffronGymSabrinaText:
	text_asm
	CheckEvent EVENT_BEAT_SABRINA
	jr z, SaffronGymSabrinaText.beforeBeat
	CheckEventReuseA EVENT_GOT_TM46
	jr nz, SaffronGymSabrinaText.afterBeat
	call z, SaffronGymSabrinaReceiveTM46Script
	call DisableWaitingAfterTextDisplay
	jr SaffronGymSabrinaText.done
SaffronGymSabrinaText.afterBeat
	ld hl, SaffronGymSabrinaText.PostBattleAdviceText
	call PrintText
	jr SaffronGymSabrinaText.done
SaffronGymSabrinaText.beforeBeat
	ld hl, SaffronGymSabrinaText.Text
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, SaffronGymSabrinaText.ReceivedMarshBadgeText
	ld de, SaffronGymSabrinaText.ReceivedMarshBadgeText
	call SaveEndBattleTextPointers
	ldh a, [lobyte(hSpriteIndex)]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $6
	ld [wGymLeaderNo], a
	ld a, SCRIPT_SAFFRONGYM_SABRINA_POST_BATTLE
	ld [wSaffronGymCurScript], a
SaffronGymSabrinaText.done
	jp TextScriptEnd

SaffronGymSabrinaText.Text:
	text_far WLA_GLOBAL_SaffronGymSabrinaText
	text_end

SaffronGymSabrinaText.ReceivedMarshBadgeText:
	text_far WLA_GLOBAL_SaffronGymSabrinaReceivedMarshBadgeText
	sound_get_key_item ; actually plays the second channel of SFX_BALL_POOF due to the wrong music bank being loaded
	text_promptbutton
	text_end

SaffronGymSabrinaText.PostBattleAdviceText:
	text_far WLA_GLOBAL_SaffronGymSabrinaPostBattleAdviceText
	text_end

SaffronGymSabrinaMarshBadgeInfoText:
	text_far WLA_GLOBAL_SaffronGymSabrinaMarshBadgeInfoText
	text_end

SaffronGymSabrinaReceivedTM46Text:
	text_far WLA_GLOBAL_SaffronGymSabrinaReceivedTM46Text
	sound_get_item_1
	text_far WLA_GLOBAL_TM46ExplanationText
	text_end

SaffronGymSabrinaTM46NoRoomText:
	text_far WLA_GLOBAL_SaffronGymSabrinaTM46NoRoomText
	text_end

SaffronGymChanneler1Text:
	text_asm
	ld hl, SaffronGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymYoungster1Text:
	text_asm
	ld hl, SaffronGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymChanneler2Text:
	text_asm
	ld hl, SaffronGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymYoungster2Text:
	text_asm
	ld hl, SaffronGymTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymChanneler3Text:
	text_asm
	ld hl, SaffronGymTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymYoungster3Text:
	text_asm
	ld hl, SaffronGymTrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymYoungster4Text:
	text_asm
	ld hl, SaffronGymTrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymGymGuideText:
	text_asm
	CheckEvent EVENT_BEAT_SABRINA
	jr nz, SaffronGymGymGuideText.afterBeat
	ld hl, SaffronGymGymGuideText.ChampInMakingText
	call PrintText
	jr SaffronGymGymGuideText.done
SaffronGymGymGuideText.afterBeat
	ld hl, SaffronGymGymGuideText.BeatSabrinaText
	call PrintText
SaffronGymGymGuideText.done
	jp TextScriptEnd

SaffronGymGymGuideText.ChampInMakingText:
	text_far WLA_GLOBAL_SaffronGymGuideChampInMakingText
	text_end

SaffronGymGymGuideText.BeatSabrinaText:
	text_far WLA_GLOBAL_SaffronGymGuideBeatSabrinaText
	text_end

SaffronGymChanneler1BattleText:
	text_far WLA_GLOBAL_SaffronGymChanneler1BattleText
	text_end

SaffronGymChanneler1EndBattleText:
	text_far WLA_GLOBAL_SaffronGymChanneler1EndBattleText
	text_end

SaffronGymChanneler1AfterBattleText:
	text_far WLA_GLOBAL_SaffronGymChanneler1AfterBattleText
	text_end

SaffronGymYoungster1BattleText:
	text_far WLA_GLOBAL_SaffronGymYoungster1BattleText
	text_end

SaffronGymYoungster1EndBattleText:
	text_far WLA_GLOBAL_SaffronGymYoungster1EndBattleText
	text_end

SaffronGymYoungster1AfterBattleText:
	text_far WLA_GLOBAL_SaffronGymYoungster1AfterBattleText
	text_end

SaffronGymChanneler2BattleText:
	text_far WLA_GLOBAL_SaffronGymChanneler2BattleText
	text_end

SaffronGymChanneler2EndBattleText:
	text_far WLA_GLOBAL_SaffronGymChanneler2EndBattleText
	text_end

SaffronGymChanneler2AfterBattleText:
	text_far WLA_GLOBAL_SaffronGymChanneler2AfterBattleText
	text_end

SaffronGymYoungster2BattleText:
	text_far WLA_GLOBAL_SaffronGymYoungster2BattleText
	text_end

SaffronGymYoungster2EndBattleText:
	text_far WLA_GLOBAL_SaffronGymYoungster2EndBattleText
	text_end

SaffronGymYoungster2AfterBattleText:
	text_far WLA_GLOBAL_SaffronGymYoungster2AfterBattleText
	text_end

SaffronGymChanneler3BattleText:
	text_far WLA_GLOBAL_SaffronGymChanneler3BattleText
	text_end

SaffronGymChanneler3EndBattleText:
	text_far WLA_GLOBAL_SaffronGymChanneler3EndBattleText
	text_end

SaffronGymChanneler3AfterBattleText:
	text_far WLA_GLOBAL_SaffronGymChanneler3AfterBattleText
	text_end

SaffronGymYoungster3BattleText:
	text_far WLA_GLOBAL_SaffronGymYoungster3BattleText
	text_end

SaffronGymYoungster3EndBattleText:
	text_far WLA_GLOBAL_SaffronGymYoungster3EndBattleText
	text_end

SaffronGymYoungster3AfterBattleText:
	text_far WLA_GLOBAL_SaffronGymYoungster3AfterBattleText
	text_end

SaffronGymYoungster4BattleText:
	text_far WLA_GLOBAL_SaffronGymYoungster4BattleText
	text_end

SaffronGymYoungster4EndBattleText:
	text_far WLA_GLOBAL_SaffronGymYoungster4EndBattleText
	text_end

SaffronGymYoungster4AfterBattleText:
	text_far WLA_GLOBAL_SaffronGymYoungster4AfterBattleText
	text_end
