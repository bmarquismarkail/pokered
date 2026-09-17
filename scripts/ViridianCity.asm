ViridianCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ViridianCity_ScriptPointers
	ld a, [wViridianCityCurScript]
	jp CallFunctionInTable

ViridianCity_ScriptPointers:
	def_script_pointers
	dw_const ViridianCityDefaultScript,                  SCRIPT_VIRIDIANCITY_DEFAULT
	dw_const ViridianCityOldManStartCatchTrainingScript, SCRIPT_VIRIDIANCITY_OLD_MAN_START_CATCH_TRAINING
	dw_const ViridianCityOldManEndCatchTrainingScript,   SCRIPT_VIRIDIANCITY_OLD_MAN_END_CATCH_TRAINING
	dw_const ViridianCityPlayerMovingDownScript,         SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN

ViridianCityDefaultScript:
	call ViridianCityCheckGymOpenScript
	jp ViridianCityCheckGotPokedexScript

ViridianCityCheckGymOpenScript:
	CheckEvent EVENT_VIRIDIAN_GYM_OPEN
	ret nz
	ld a, [wObtainedBadges]
	cp ~(1 << BIT_EARTHBADGE)
	jr nz, ViridianCityCheckGymOpenScript.gym_closed
	SetEvent EVENT_VIRIDIAN_GYM_OPEN
	ret
ViridianCityCheckGymOpenScript.gym_closed
	ld a, [wYCoord]
	cp 8
	ret nz
	ld a, [wXCoord]
	cp 32
	ret nz
	ld a, TEXT_VIRIDIANCITY_GYM_LOCKED
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	xor a
	ldh [lobyte(hJoyHeld)], a
	call ViridianCityMovePlayerDownScript
	ld a, SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN
	ld [wViridianCityCurScript], a
	ret

ViridianCityCheckGotPokedexScript:
	CheckEvent EVENT_GOT_POKEDEX
	ret nz
	ld a, [wYCoord]
	cp 9
	ret nz
	ld a, [wXCoord]
	cp 19
	ret nz
	ld a, TEXT_VIRIDIANCITY_OLD_MAN_SLEEPY
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	xor a
	ldh [lobyte(hJoyHeld)], a
	call ViridianCityMovePlayerDownScript
	ld a, SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN
	ld [wViridianCityCurScript], a
	ret

ViridianCityOldManStartCatchTrainingScript:
	ld a, [wSprite03StateData1YPixels]
	ldh [lobyte(hSpriteScreenYCoord)], a
	ld a, [wSprite03StateData1XPixels]
	ldh [lobyte(hSpriteScreenXCoord)], a
	ld a, [wSprite03StateData2MapY]
	ldh [lobyte(hSpriteMapYCoord)], a
	ld a, [wSprite03StateData2MapX]
	ldh [lobyte(hSpriteMapXCoord)], a
	xor a
	ld [wListScrollOffset], a

	; set up battle for Old Man
	ld a, BATTLE_TYPE_OLD_MAN
	ld [wBattleType], a
	ld a, 5
	ld [wCurEnemyLevel], a
	ld a, WEEDLE
	ld [wCurOpponent], a
	ld a, SCRIPT_VIRIDIANCITY_OLD_MAN_END_CATCH_TRAINING
	ld [wViridianCityCurScript], a
	ret

ViridianCityOldManEndCatchTrainingScript:
	ldh a, [lobyte(hSpriteScreenYCoord)]
	ld [wSprite03StateData1YPixels], a
	ldh a, [lobyte(hSpriteScreenXCoord)]
	ld [wSprite03StateData1XPixels], a
	ldh a, [lobyte(hSpriteMapYCoord)]
	ld [wSprite03StateData2MapY], a
	ldh a, [lobyte(hSpriteMapXCoord)]
	ld [wSprite03StateData2MapX], a
	call UpdateSprites
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_VIRIDIANCITY_OLD_MAN_YOU_NEED_TO_WEAKEN_THE_TARGET
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	xor a
	ld [wBattleType], a
	ld [wJoyIgnore], a
	ld a, SCRIPT_VIRIDIANCITY_DEFAULT
	ld [wViridianCityCurScript], a
	ret

ViridianCityPlayerMovingDownScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, SCRIPT_VIRIDIANCITY_DEFAULT
	ld [wViridianCityCurScript], a
	ret

ViridianCityMovePlayerDownScript:
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld [wJoyIgnore], a
	ret

ViridianCity_TextPointers:
	def_text_pointers
	dw_const ViridianCityYoungster1Text,                     TEXT_VIRIDIANCITY_YOUNGSTER1
	dw_const ViridianCityGambler1Text,                       TEXT_VIRIDIANCITY_GAMBLER1
	dw_const ViridianCityYoungster2Text,                     TEXT_VIRIDIANCITY_YOUNGSTER2
	dw_const ViridianCityGirlText,                           TEXT_VIRIDIANCITY_GIRL
	dw_const ViridianCityOldManSleepyText,                   TEXT_VIRIDIANCITY_OLD_MAN_SLEEPY
	dw_const ViridianCityFisherText,                         TEXT_VIRIDIANCITY_FISHER
	dw_const ViridianCityOldManText,                         TEXT_VIRIDIANCITY_OLD_MAN
	dw_const ViridianCitySignText,                           TEXT_VIRIDIANCITY_SIGN
	dw_const ViridianCityTrainerTips1Text,                   TEXT_VIRIDIANCITY_TRAINER_TIPS1
	dw_const ViridianCityTrainerTips2Text,                   TEXT_VIRIDIANCITY_TRAINER_TIPS2
	dw_const MartSignText,                                   TEXT_VIRIDIANCITY_MART_SIGN
	dw_const PokeCenterSignText,                             TEXT_VIRIDIANCITY_POKECENTER_SIGN
	dw_const ViridianCityGymSignText,                        TEXT_VIRIDIANCITY_GYM_SIGN
	dw_const ViridianCityGymLockedText,                      TEXT_VIRIDIANCITY_GYM_LOCKED
	dw_const ViridianCityOldManYouNeedToWeakenTheTargetText, TEXT_VIRIDIANCITY_OLD_MAN_YOU_NEED_TO_WEAKEN_THE_TARGET

ViridianCityYoungster1Text:
	text_far WLA_GLOBAL_ViridianCityYoungster1Text
	text_end

ViridianCityGambler1Text:
	text_asm
	ld a, [wObtainedBadges]
	cp ~(1 << BIT_EARTHBADGE)
	ld hl, ViridianCityGambler1Text.GymLeaderReturnedText
	jr z, ViridianCityGambler1Text.print_text
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr nz, ViridianCityGambler1Text.print_text
	ld hl, ViridianCityGambler1Text.GymAlwaysClosedText
ViridianCityGambler1Text.print_text
	call PrintText
	jp TextScriptEnd

ViridianCityGambler1Text.GymAlwaysClosedText:
	text_far WLA_GLOBAL_ViridianCityGambler1GymAlwaysClosedText
	text_end

ViridianCityGambler1Text.GymLeaderReturnedText:
	text_far WLA_GLOBAL_ViridianCityGambler1GymLeaderReturnedText
	text_end

ViridianCityYoungster2Text:
	text_asm
	ld hl, ViridianCityYoungster2Text.YouWantToKnowAboutText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, ViridianCityYoungster2Text.no
	ld hl, ViridianCityYoungster2Text.CaterpieAndWeedleDescriptionText
	call PrintText
	jr ViridianCityYoungster2Text.text_script_end
ViridianCityYoungster2Text.no
	ld hl, ViridianCityYoungster2Text.OkThenText
	call PrintText
ViridianCityYoungster2Text.text_script_end
	jp TextScriptEnd

ViridianCityYoungster2Text.YouWantToKnowAboutText:
	text_far WLA_GLOBAL_ViridianCityYoungster2YouWantToKnowAboutText
	text_end

ViridianCityYoungster2Text.OkThenText:
	text_far ViridianCityYoungster2OkThenText
	text_end

ViridianCityYoungster2Text.CaterpieAndWeedleDescriptionText:
	text_far ViridianCityYoungster2CaterpieAndWeedleDescriptionText
	text_end

ViridianCityGirlText:
	text_asm
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, ViridianCityGirlText.got_pokedex
	ld hl, ViridianCityGirlText.HasntHadHisCoffeeYetText
	call PrintText
	jr ViridianCityGirlText.text_script_end
ViridianCityGirlText.got_pokedex
	ld hl, ViridianCityGirlText.WhenIGoShopText
	call PrintText
ViridianCityGirlText.text_script_end
	jp TextScriptEnd

ViridianCityGirlText.HasntHadHisCoffeeYetText:
	text_far WLA_GLOBAL_ViridianCityGirlHasntHadHisCoffeeYetText
	text_end

ViridianCityGirlText.WhenIGoShopText:
	text_far WLA_GLOBAL_ViridianCityGirlWhenIGoShopText
	text_end

ViridianCityOldManSleepyText:
	text_asm
	ld hl, ViridianCityOldManSleepyText.PrivatePropertyText
	call PrintText
	call ViridianCityMovePlayerDownScript
	ld a, SCRIPT_VIRIDIANCITY_PLAYER_MOVING_DOWN
	ld [wViridianCityCurScript], a
	jp TextScriptEnd

ViridianCityOldManSleepyText.PrivatePropertyText:
	text_far WLA_GLOBAL_ViridianCityOldManSleepyPrivatePropertyText
	text_end

ViridianCityFisherText:
	text_asm
	CheckEvent EVENT_GOT_TM42
	jr nz, ViridianCityFisherText.got_item
	ld hl, ViridianCityFisherText.YouCanHaveThisText
	call PrintText
	lb "bc", TM_DREAM_EATER, 1
	call GiveItem
	jr nc, ViridianCityFisherText.bag_full
	ld hl, ViridianCityFisherText.ReceivedTM42Text
	call PrintText
	SetEvent EVENT_GOT_TM42
	jr ViridianCityFisherText.done
ViridianCityFisherText.bag_full
	ld hl, ViridianCityFisherText.TM42NoRoomText
	call PrintText
	jr ViridianCityFisherText.done
ViridianCityFisherText.got_item
	ld hl, ViridianCityFisherText.TM42ExplanationText
	call PrintText
ViridianCityFisherText.done
	jp TextScriptEnd

ViridianCityFisherText.YouCanHaveThisText:
	text_far ViridianCityFisherYouCanHaveThisText
	text_end

ViridianCityFisherText.ReceivedTM42Text:
	text_far WLA_GLOBAL_ViridianCityFisherReceivedTM42Text
	sound_get_item_2
	text_end

ViridianCityFisherText.TM42ExplanationText:
	text_far WLA_GLOBAL_ViridianCityFisherTM42ExplanationText
	text_end

ViridianCityFisherText.TM42NoRoomText:
	text_far WLA_GLOBAL_ViridianCityFisherTM42NoRoomText
	text_end

ViridianCityOldManText:
	text_asm
	ld hl, ViridianCityOldManText.HadMyCoffeeNowText
	call PrintText
	ld c, 2
	call DelayFrames
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr z, ViridianCityOldManText.refused
	ld hl, ViridianCityOldManText.KnowHowToCatchPokemonText
	call PrintText
	ld a, SCRIPT_VIRIDIANCITY_OLD_MAN_START_CATCH_TRAINING
	ld [wViridianCityCurScript], a
	jr ViridianCityOldManText.done
ViridianCityOldManText.refused
	ld hl, ViridianCityOldManText.TimeIsMoneyText
	call PrintText
ViridianCityOldManText.done
	jp TextScriptEnd

ViridianCityOldManText.HadMyCoffeeNowText:
	text_far WLA_GLOBAL_ViridianCityOldManHadMyCoffeeNowText
	text_end

ViridianCityOldManText.KnowHowToCatchPokemonText:
	text_far WLA_GLOBAL_ViridianCityOldManKnowHowToCatchPokemonText
	text_end

ViridianCityOldManText.TimeIsMoneyText:
	text_far WLA_GLOBAL_ViridianCityOldManTimeIsMoneyText
	text_end

ViridianCityOldManYouNeedToWeakenTheTargetText:
	text_far WLA_GLOBAL_ViridianCityOldManYouNeedToWeakenTheTargetText
	text_end

ViridianCitySignText:
	text_far WLA_GLOBAL_ViridianCitySignText
	text_end

ViridianCityTrainerTips1Text:
	text_far WLA_GLOBAL_ViridianCityTrainerTips1Text
	text_end

ViridianCityTrainerTips2Text:
	text_far WLA_GLOBAL_ViridianCityTrainerTips2Text
	text_end

ViridianCityGymSignText:
	text_far WLA_GLOBAL_ViridianCityGymSignText
	text_end

ViridianCityGymLockedText:
	text_far WLA_GLOBAL_ViridianCityGymLockedText
	text_end
