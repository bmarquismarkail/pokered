PewterCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PewterCity_ScriptPointers
	ld a, [wPewterCityCurScript]
	jp CallFunctionInTable

PewterCity_ScriptPointers:
	def_script_pointers
	dw_const PewterCityDefaultScript,                     SCRIPT_PEWTERCITY_DEFAULT
	dw_const PewterCitySuperNerd1ShowsPlayerMuseumScript, SCRIPT_PEWTERCITY_SUPER_NERD1_SHOWS_PLAYER_MUSEUM
	dw_const PewterCityHideSuperNerd1Script,              SCRIPT_PEWTERCITY_HIDE_SUPER_NERD1
	dw_const PewterCityResetSuperNerd1Script,             SCRIPT_PEWTERCITY_RESET_SUPER_NERD1
	dw_const PewterCityYoungsterShowsPlayerGymScript,     SCRIPT_PEWTERCITY_YOUNGSTER_SHOWS_PLAYER_GYM
	dw_const PewterCityHideYoungsterScript,               SCRIPT_PEWTERCITY_HIDE_YOUNGSTER
	dw_const PewterCityResetYoungsterScript,              SCRIPT_PEWTERCITY_RESET_YOUNGSTER

PewterCityDefaultScript:
	xor a
	ld [wMuseum1FCurScript], a
	ResetEvent EVENT_BOUGHT_MUSEUM_TICKET
	call PewterCityCheckPlayerLeavingEastScript
	ret

PewterCityCheckPlayerLeavingEastScript:
	CheckEvent EVENT_BEAT_BROCK
	ret nz
.IF defined(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
.ENDIF
	ld hl, PewterCityPlayerLeavingEastCoords
	call ArePlayerCoordsInArray
	ret nc
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_PEWTERCITY_YOUNGSTER
	ldh [lobyte(hTextID)], a
	jp DisplayTextID

PewterCityPlayerLeavingEastCoords:
	dbmapcoord 35, 17
	dbmapcoord 36, 17
	dbmapcoord 37, 18
	dbmapcoord 37, 19
	.DB -1 ; end

PewterCitySuperNerd1ShowsPlayerMuseumScript:
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
	ld a, PEWTERCITY_SUPER_NERD1
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITE_FACING_UP
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, ($3 << 4) | SPRITE_FACING_UP
	ldh [lobyte(hSpriteImageIndex)], a
	call SetSpriteImageIndexAfterSettingFacingDirection
	call PlayDefaultMusic
	ld hl, wMiscFlags
	set BIT_NO_SPRITE_UPDATES, [hl]
	ld a, TEXT_PEWTERCITY_SUPER_NERD1_ITS_RIGHT_HERE
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld a, $3c
	ldh [lobyte(hSpriteScreenYCoord)], a
	ld a, $30
	ldh [lobyte(hSpriteScreenXCoord)], a
	ld a, 12
	ldh [lobyte(hSpriteMapYCoord)], a
	ld a, 17
	ldh [lobyte(hSpriteMapXCoord)], a
	ld a, PEWTERCITY_SUPER_NERD1
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ld a, PEWTERCITY_SUPER_NERD1
	ldh [lobyte(hSpriteIndex)], a
	ld de, MovementData_PewterMuseumGuyExit
	call MoveSprite
	ld a, SCRIPT_PEWTERCITY_HIDE_SUPER_NERD1
	ld [wPewterCityCurScript], a
	ret

MovementData_PewterMuseumGuyExit:
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB -1 ; end

PewterCityHideSuperNerd1Script:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_MUSEUM_GUY
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, SCRIPT_PEWTERCITY_RESET_SUPER_NERD1
	ld [wPewterCityCurScript], a
	ret

PewterCityResetSuperNerd1Script:
	ld a, PEWTERCITY_SUPER_NERD1
	ld [wSpriteIndex], a
	call SetSpritePosition2
	ld a, TOGGLE_MUSEUM_GUY
	ld [wToggleableObjectIndex], a
	predef ShowObject
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_PEWTERCITY_DEFAULT
	ld [wPewterCityCurScript], a
	ret

PewterCityYoungsterShowsPlayerGymScript:
	ld a, [wNPCMovementScriptPointerTableNum]
	and a
	ret nz
	ld a, PEWTERCITY_YOUNGSTER
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITE_FACING_LEFT
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, ($1 << 4) | SPRITE_FACING_LEFT
	ldh [lobyte(hSpriteImageIndex)], a
	call SetSpriteImageIndexAfterSettingFacingDirection
	call PlayDefaultMusic
	ld hl, wMiscFlags
	set BIT_NO_SPRITE_UPDATES, [hl]
	ld a, TEXT_PEWTERCITY_YOUNGSTER_GO_TAKE_ON_BROCK
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld a, $3c
	ldh [lobyte(hSpriteScreenYCoord)], a
	ld a, $40 ; BUG: should load $50, using $40 causes sprite misalignment
	ldh [lobyte(hSpriteScreenXCoord)], a
	ld a, 22
	ldh [lobyte(hSpriteMapYCoord)], a
	ld a, 16
	ldh [lobyte(hSpriteMapXCoord)], a
	ld a, PEWTERCITY_YOUNGSTER
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ld a, PEWTERCITY_YOUNGSTER
	ldh [lobyte(hSpriteIndex)], a
	ld de, MovementData_PewterGymGuyExit
	call MoveSprite
	ld a, SCRIPT_PEWTERCITY_HIDE_YOUNGSTER
	ld [wPewterCityCurScript], a
	ret

MovementData_PewterGymGuyExit:
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_RIGHT
	.DB -1 ; end

PewterCityHideYoungsterScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_GYM_GUY
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, SCRIPT_PEWTERCITY_RESET_YOUNGSTER
	ld [wPewterCityCurScript], a
	ret

PewterCityResetYoungsterScript:
	ld a, PEWTERCITY_YOUNGSTER
	ld [wSpriteIndex], a
	call SetSpritePosition2
	ld a, TOGGLE_GYM_GUY
	ld [wToggleableObjectIndex], a
	predef ShowObject
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_PEWTERCITY_DEFAULT
	ld [wPewterCityCurScript], a
	ret

PewterCity_TextPointers:
	def_text_pointers
	dw_const PewterCityCooltrainerFText,           TEXT_PEWTERCITY_COOLTRAINER_F
	dw_const PewterCityCooltrainerMText,           TEXT_PEWTERCITY_COOLTRAINER_M
	dw_const PewterCitySuperNerd1Text,             TEXT_PEWTERCITY_SUPER_NERD1
	dw_const PewterCitySuperNerd2Text,             TEXT_PEWTERCITY_SUPER_NERD2
	dw_const PewterCityYoungsterText,              TEXT_PEWTERCITY_YOUNGSTER
	dw_const PewterCityTrainerTipsText,            TEXT_PEWTERCITY_TRAINER_TIPS
	dw_const PewterCityPoliceNoticeSignText,       TEXT_PEWTERCITY_POLICE_NOTICE_SIGN
	dw_const MartSignText,                         TEXT_PEWTERCITY_MART_SIGN
	dw_const PokeCenterSignText,                   TEXT_PEWTERCITY_POKECENTER_SIGN
	dw_const PewterCityMuseumSignText,             TEXT_PEWTERCITY_MUSEUM_SIGN
	dw_const PewterCityGymSignText,                TEXT_PEWTERCITY_GYM_SIGN
	dw_const PewterCitySignText,                   TEXT_PEWTERCITY_SIGN
	dw_const PewterCitySuperNerd1ItsRightHereText, TEXT_PEWTERCITY_SUPER_NERD1_ITS_RIGHT_HERE
	dw_const PewterCityYoungsterGoTakeOnBrockText, TEXT_PEWTERCITY_YOUNGSTER_GO_TAKE_ON_BROCK

PewterCityCooltrainerFText:
	text_far WLA_GLOBAL_PewterCityCooltrainerFText
	text_end

PewterCityCooltrainerMText:
	text_far WLA_GLOBAL_PewterCityCooltrainerMText
	text_end

PewterCitySuperNerd1Text:
	text_asm
	ld hl, PewterCitySuperNerd1Text.DidYouCheckOutMuseumText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, PewterCitySuperNerd1Text.playerDidNotGoIntoMuseum
	ld hl, PewterCitySuperNerd1Text.WerentThoseFossilsAmazingText
	call PrintText
	jr PewterCitySuperNerd1Text.done
PewterCitySuperNerd1Text.playerDidNotGoIntoMuseum
	ld hl, PewterCitySuperNerd1Text.YouHaveToGoText
	call PrintText
	xor a
	ldh [lobyte(hJoyPressed)], a
	ldh [lobyte(hJoyHeld)], a
	ld [wNPCMovementScriptFunctionNum], a
	ld a, $2
	ld [wNPCMovementScriptPointerTableNum], a
	ldh a, [lobyte(hLoadedROMBank)]
	ld [wNPCMovementScriptBank], a
	ld a, PEWTERCITY_SUPER_NERD1
	ld [wSpriteIndex], a
	call GetSpritePosition2
	ld a, SCRIPT_PEWTERCITY_SUPER_NERD1_SHOWS_PLAYER_MUSEUM
	ld [wPewterCityCurScript], a
PewterCitySuperNerd1Text.done
	jp TextScriptEnd

PewterCitySuperNerd1Text.DidYouCheckOutMuseumText:
	text_far WLA_GLOBAL_PewterCitySuperNerd1DidYouCheckOutMuseumText
	text_end

PewterCitySuperNerd1Text.WerentThoseFossilsAmazingText:
	text_far WLA_GLOBAL_PewterCitySuperNerd1WerentThoseFossilsAmazingText
	text_end

PewterCitySuperNerd1Text.YouHaveToGoText:
	text_far WLA_GLOBAL_PewterCitySuperNerd1YouHaveToGoText
	text_end

PewterCitySuperNerd1ItsRightHereText:
	text_far WLA_GLOBAL_PewterCitySuperNerd1ItsRightHereText
	text_end

PewterCitySuperNerd2Text:
	text_asm
	ld hl, PewterCitySuperNerd2Text.DoYouKnowWhatImDoingText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	cp $0
	jr nz, PewterCitySuperNerd2Text.playerDoesNotKnow
	ld hl, PewterCitySuperNerd2Text.ThatsRightText
	call PrintText
	jr PewterCitySuperNerd2Text.done
PewterCitySuperNerd2Text.playerDoesNotKnow
	ld hl, PewterCitySuperNerd2Text.ImSprayingRepelText
	call PrintText
PewterCitySuperNerd2Text.done
	jp TextScriptEnd

PewterCitySuperNerd2Text.DoYouKnowWhatImDoingText:
	text_far WLA_GLOBAL_PewterCitySuperNerd2DoYouKnowWhatImDoingText
	text_end

PewterCitySuperNerd2Text.ThatsRightText:
	text_far WLA_GLOBAL_PewterCitySuperNerd2ThatsRightText
	text_end

PewterCitySuperNerd2Text.ImSprayingRepelText:
	text_far WLA_GLOBAL_PewterCitySuperNerd2ImSprayingRepelText
	text_end

PewterCityYoungsterText:
	text_asm
	ld hl, PewterCityYoungsterText.YoureATrainerFollowMeText
	call PrintText
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld [wNPCMovementScriptFunctionNum], a
	ld a, $3
	ld [wNPCMovementScriptPointerTableNum], a
	ldh a, [lobyte(hLoadedROMBank)]
	ld [wNPCMovementScriptBank], a
	ld a, PEWTERCITY_YOUNGSTER
	ld [wSpriteIndex], a
	call GetSpritePosition2
	ld a, SCRIPT_PEWTERCITY_YOUNGSTER_SHOWS_PLAYER_GYM
	ld [wPewterCityCurScript], a
	jp TextScriptEnd

PewterCityYoungsterText.YoureATrainerFollowMeText:
	text_far WLA_GLOBAL_PewterCityYoungsterYoureATrainerFollowMeText
	text_end

PewterCityYoungsterGoTakeOnBrockText:
	text_far WLA_GLOBAL_PewterCityYoungsterGoTakeOnBrockText
	text_end

PewterCityTrainerTipsText:
	text_far WLA_GLOBAL_PewterCityTrainerTipsText
	text_end

PewterCityPoliceNoticeSignText:
	text_far WLA_GLOBAL_PewterCityPoliceNoticeSignText
	text_end

PewterCityMuseumSignText:
	text_far WLA_GLOBAL_PewterCityMuseumSignText
	text_end

PewterCityGymSignText:
	text_far WLA_GLOBAL_PewterCityGymSignText
	text_end

PewterCitySignText:
	text_far WLA_GLOBAL_PewterCitySignText
	text_end
