VermilionCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	push hl
	call nz, VermilionCityLeftSSAnneCallbackScript
	pop hl
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	call nz, VermilionCity_Script.setFirstLockTrashCanIndex
	ld hl, VermilionCity_ScriptPointers
	ld a, [wVermilionCityCurScript]
	jp CallFunctionInTable

VermilionCity_Script.setFirstLockTrashCanIndex
	call Random
	ldh a, [lobyte(hRandomSub)]
	and $e
	ld [wFirstLockTrashCanIndex], a
	ret

VermilionCityLeftSSAnneCallbackScript:
	CheckEventHL EVENT_SS_ANNE_LEFT
	ret z
	CheckEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	SetEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	ret nz
	ld a, SCRIPT_VERMILIONCITY_PLAYER_EXIT_SHIP
	ld [wVermilionCityCurScript], a
	ret

VermilionCity_ScriptPointers:
	def_script_pointers
	dw_const VermilionCityDefaultScript,             SCRIPT_VERMILIONCITY_DEFAULT
	dw_const VermilionCityPlayerMovingUp1Script,     SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP1
	dw_const VermilionCityPlayerExitShipScript,      SCRIPT_VERMILIONCITY_PLAYER_EXIT_SHIP
	dw_const VermilionCityPlayerMovingUp2Script,     SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP2
	dw_const VermilionCityPlayerAllowedToPassScript, SCRIPT_VERMILIONCITY_PLAYER_ALLOWED_TO_PASS

VermilionCityDefaultScript:
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	ret nz
	ld hl, SSAnneTicketCheckCoords
	call ArePlayerCoordsInArray
	ret nc
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld [wSavedCoordIndex], a ; unnecessary
	ld a, TEXT_VERMILIONCITY_SAILOR1
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, VermilionCityDefaultScript.ship_departed
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ret nz
VermilionCityDefaultScript.ship_departed
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP1
	ld [wVermilionCityCurScript], a
	ret

SSAnneTicketCheckCoords:
	dbmapcoord 18, 30
	.DB -1 ; end

VermilionCityPlayerAllowedToPassScript:
	ld hl, SSAnneTicketCheckCoords
	call ArePlayerCoordsInArray
	ret c
	ld a, SCRIPT_VERMILIONCITY_DEFAULT
	ld [wVermilionCityCurScript], a
	ret

VermilionCityPlayerExitShipScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, PAD_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP2
	ld [wVermilionCityCurScript], a
	ret

VermilionCityPlayerMovingUp2Script:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ldh [lobyte(hJoyHeld)], a
	ld a, SCRIPT_VERMILIONCITY_DEFAULT
	ld [wVermilionCityCurScript], a
	ret

VermilionCityPlayerMovingUp1Script:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld c, 10
	call DelayFrames
	ld a, SCRIPT_VERMILIONCITY_DEFAULT
	ld [wVermilionCityCurScript], a
	ret

VermilionCity_TextPointers:
	def_text_pointers
	dw_const VermilionCityBeautyText,             TEXT_VERMILIONCITY_BEAUTY
	dw_const VermilionCityGambler1Text,           TEXT_VERMILIONCITY_GAMBLER1
	dw_const VermilionCitySailor1Text,            TEXT_VERMILIONCITY_SAILOR1
	dw_const VermilionCityGambler2Text,           TEXT_VERMILIONCITY_GAMBLER2
	dw_const VermilionCityMachopText,             TEXT_VERMILIONCITY_MACHOP
	dw_const VermilionCitySailor2Text,            TEXT_VERMILIONCITY_SAILOR2
	dw_const VermilionCitySignText,               TEXT_VERMILIONCITY_SIGN
	dw_const VermilionCityNoticeSignText,         TEXT_VERMILIONCITY_NOTICE_SIGN
	dw_const MartSignText,                        TEXT_VERMILIONCITY_MART_SIGN
	dw_const PokeCenterSignText,                  TEXT_VERMILIONCITY_POKECENTER_SIGN
	dw_const VermilionCityPokemonFanClubSignText, TEXT_VERMILIONCITY_POKEMON_FAN_CLUB_SIGN
	dw_const VermilionCityGymSignText,            TEXT_VERMILIONCITY_GYM_SIGN
	dw_const VermilionCityHarborSignText,         TEXT_VERMILIONCITY_HARBOR_SIGN

VermilionCityBeautyText:
	text_far WLA_GLOBAL_VermilionCityBeautyText
	text_end

VermilionCityGambler1Text:
	text_asm
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, VermilionCityGambler1Text.ship_departed
	ld hl, VermilionCityGambler1Text.DidYouSeeText
	call PrintText
	jr VermilionCityGambler1Text.text_script_end
VermilionCityGambler1Text.ship_departed
	ld hl, VermilionCityGambler1Text.SSAnneDepartedText
	call PrintText
VermilionCityGambler1Text.text_script_end
	jp TextScriptEnd

VermilionCityGambler1Text.DidYouSeeText:
	text_far WLA_GLOBAL_VermilionCityGambler1DidYouSeeText
	text_end

VermilionCityGambler1Text.SSAnneDepartedText:
	text_far WLA_GLOBAL_VermilionCityGambler1SSAnneDepartedText
	text_end

VermilionCitySailor1Text:
	text_asm
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, VermilionCitySailor1Text.ship_departed
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_RIGHT
	jr z, VermilionCitySailor1Text.greet_player
	ld hl, VermilionCitySailor1Text.inFrontOfOrBehindGuardCoords
	call ArePlayerCoordsInArray
	jr nc, VermilionCitySailor1Text.greet_player_and_check_ticket
VermilionCitySailor1Text.greet_player
	ld hl, VermilionCitySailor1Text.WelcomeToSSAnneText
	call PrintText
	jr VermilionCitySailor1Text.end
VermilionCitySailor1Text.greet_player_and_check_ticket
	ld hl, VermilionCitySailor1Text.DoYouHaveATicketText
	call PrintText
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr nz, VermilionCitySailor1Text.player_has_ticket
	ld hl, VermilionCitySailor1Text.YouNeedATicketText
	call PrintText
	jr VermilionCitySailor1Text.end
VermilionCitySailor1Text.player_has_ticket
	ld hl, VermilionCitySailor1Text.FlashedTicketText
	call PrintText
	ld a, SCRIPT_VERMILIONCITY_PLAYER_ALLOWED_TO_PASS
	ld [wVermilionCityCurScript], a
	jr VermilionCitySailor1Text.end
VermilionCitySailor1Text.ship_departed
	ld hl, VermilionCitySailor1Text.ShipSetSailText
	call PrintText
VermilionCitySailor1Text.end
	jp TextScriptEnd

VermilionCitySailor1Text.inFrontOfOrBehindGuardCoords
	dbmapcoord 19, 29 ; in front of guard
	dbmapcoord 19, 31 ; behind guard
	.DB -1 ; end

VermilionCitySailor1Text.WelcomeToSSAnneText:
	text_far WLA_GLOBAL_VermilionCitySailor1WelcomeToSSAnneText
	text_end

VermilionCitySailor1Text.DoYouHaveATicketText:
	text_far WLA_GLOBAL_VermilionCitySailor1DoYouHaveATicketText
	text_end

VermilionCitySailor1Text.FlashedTicketText:
	text_far WLA_GLOBAL_VermilionCitySailor1FlashedTicketText
	text_end

VermilionCitySailor1Text.YouNeedATicketText:
	text_far WLA_GLOBAL_VermilionCitySailor1YouNeedATicketText
	text_end

VermilionCitySailor1Text.ShipSetSailText:
	text_far WLA_GLOBAL_VermilionCitySailor1ShipSetSailText
	text_end

VermilionCityGambler2Text:
	text_far WLA_GLOBAL_VermilionCityGambler2Text
	text_end

VermilionCityMachopText:
	text_far WLA_GLOBAL_VermilionCityMachopText
	text_asm
	ld a, MACHOP
	call PlayCry
	call WaitForSoundToFinish
	ld hl, VermilionCityMachopText.StompingTheLandFlatText
	ret

VermilionCityMachopText.StompingTheLandFlatText:
	text_far WLA_GLOBAL_VermilionCityMachopStompingTheLandFlatText
	text_end

VermilionCitySailor2Text:
	text_far WLA_GLOBAL_VermilionCitySailor2Text
	text_end

VermilionCitySignText:
	text_far WLA_GLOBAL_VermilionCitySignText
	text_end

VermilionCityNoticeSignText:
	text_far WLA_GLOBAL_VermilionCityNoticeSignText
	text_end

VermilionCityPokemonFanClubSignText:
	text_far WLA_GLOBAL_VermilionCityPokemonFanClubSignText
	text_end

VermilionCityGymSignText:
	text_far WLA_GLOBAL_VermilionCityGymSignText
	text_end

VermilionCityHarborSignText:
	text_far WLA_GLOBAL_VermilionCityHarborSignText
	text_end
