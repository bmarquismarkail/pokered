CeruleanCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, CeruleanCity_ScriptPointers
	ld a, [wCeruleanCityCurScript]
	jp CallFunctionInTable

CeruleanCityClearScripts:
	xor a ; SCRIPT_CERULEANCITY_DEFAULT
	ld [wJoyIgnore], a
	ld [wCeruleanCityCurScript], a
	ld a, TOGGLE_CERULEAN_RIVAL
	ld [wToggleableObjectIndex], a
	predef_jump HideObject

CeruleanCity_ScriptPointers:
	def_script_pointers
	dw_const CeruleanCityDefaultScript,        SCRIPT_CERULEANCITY_DEFAULT
	dw_const CeruleanCityRivalBattleScript,    SCRIPT_CERULEANCITY_RIVAL_BATTLE
	dw_const CeruleanCityRivalDefeatedScript,  SCRIPT_CERULEANCITY_RIVAL_DEFEATED
	dw_const CeruleanCityRivalCleanupScript,   SCRIPT_CERULEANCITY_RIVAL_CLEANUP
	dw_const CeruleanCityRocketDefeatedScript, SCRIPT_CERULEANCITY_ROCKET_DEFEATED

CeruleanCityRocketDefeatedScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CeruleanCityClearScripts
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_CERULEAN_ROCKET_THIEF
	ld a, TEXT_CERULEANCITY_ROCKET
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	xor a ; SCRIPT_CERULEANCITY_DEFAULT
	ld [wJoyIgnore], a
	ld [wCeruleanCityCurScript], a
	ret

CeruleanCityDefaultScript:
.IF defined(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
.ENDIF
	CheckEvent EVENT_BEAT_CERULEAN_ROCKET_THIEF
	jr nz, CeruleanCityDefaultScript.skipRocketThiefEncounter
	ld hl, CeruleanCityCoords1
	call ArePlayerCoordsInArray
	jr nc, CeruleanCityDefaultScript.skipRocketThiefEncounter
	ld a, [wCoordIndex]
	cp $1
	ld a, PLAYER_DIR_UP
	ld b, SPRITE_FACING_DOWN
	jr nz, CeruleanCityDefaultScript.playerBelowRocketThief
	ld a, PLAYER_DIR_DOWN
	ld b, SPRITE_FACING_UP
CeruleanCityDefaultScript.playerBelowRocketThief
	ld [wPlayerMovingDirection], a
	ld a, b
	ld [wSprite02StateData1FacingDirection], a
	call Delay3
	ld a, TEXT_CERULEANCITY_ROCKET
	ldh [lobyte(hTextID)], a
	jp DisplayTextID
CeruleanCityDefaultScript.skipRocketThiefEncounter
	CheckEvent EVENT_BEAT_CERULEAN_RIVAL
	ret nz
	ld hl, CeruleanCityCoords2
	call ArePlayerCoordsInArray
	ret nc
	ld a, [wWalkBikeSurfState]
	and a
	jr z, CeruleanCityDefaultScript.walking
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
CeruleanCityDefaultScript.walking
	ld c, bank(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, [wXCoord]
	cp 20 ; is the player standing on the right side of the bridge?
	jr z, CeruleanCityDefaultScript.playerOnRightSideOfBridge
	ld a, CERULEANCITY_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITESTATEDATA2_MAPX
	ldh [lobyte(hSpriteDataOffset)], a
	call GetPointerWithinSpriteStateData2
	ld [hl], 25
CeruleanCityDefaultScript.playerOnRightSideOfBridge
	ld a, TOGGLE_CERULEAN_RIVAL
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld de, CeruleanCityMovement1
	ld a, CERULEANCITY_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	call MoveSprite
	ld a, SCRIPT_CERULEANCITY_RIVAL_BATTLE
	ld [wCeruleanCityCurScript], a
	ret

CeruleanCityCoords1:
	dbmapcoord 30,  7
	dbmapcoord 30,  9
	.DB -1 ; end

CeruleanCityCoords2:
	dbmapcoord 20,  6
	dbmapcoord 21,  6
	.DB -1 ; end

CeruleanCityMovement1:
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB -1 ; end

CeruleanCityFaceRivalScript:
	ld a, CERULEANCITY_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	xor a ; SPRITE_FACING_DOWN
	ldh [lobyte(hSpriteFacingDirection)], a
	jp SetSpriteFacingDirectionAndDelay ; face object

CeruleanCityRivalBattleScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, TEXT_CERULEANCITY_RIVAL
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, CeruleanCityRivalDefeatedText
	ld de, CeruleanCityRivalVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_RIVAL1
	ld [wCurOpponent], a

	; select which team to use during the encounter
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, CeruleanCityRivalBattleScript.NotSquirtle
	ld a, $7
	jr CeruleanCityRivalBattleScript.done
CeruleanCityRivalBattleScript.NotSquirtle
	cp STARTER3
	jr nz, CeruleanCityRivalBattleScript.Charmander
	ld a, $8
	jr CeruleanCityRivalBattleScript.done
CeruleanCityRivalBattleScript.Charmander
	ld a, $9
CeruleanCityRivalBattleScript.done
	ld [wTrainerNo], a

	xor a
	ldh [lobyte(hJoyHeld)], a
	call CeruleanCityFaceRivalScript
	ld a, SCRIPT_CERULEANCITY_RIVAL_DEFEATED
	ld [wCeruleanCityCurScript], a
	ret

CeruleanCityRivalDefeatedScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CeruleanCityClearScripts
	call CeruleanCityFaceRivalScript
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_CERULEAN_RIVAL
	ld a, TEXT_CERULEANCITY_RIVAL
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	farcall Music_RivalAlternateStart
	ld a, CERULEANCITY_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	call SetSpriteMovementBytesToFF
	ld a, [wXCoord]
	cp 20 ; is the player standing on the right side of the bridge?
	jr nz, CeruleanCityRivalDefeatedScript.playerOnRightSideOfBridge
	ld de, CeruleanCityMovement4
	jr CeruleanCityRivalDefeatedScript.skip
CeruleanCityRivalDefeatedScript.playerOnRightSideOfBridge
	ld de, CeruleanCityMovement3
CeruleanCityRivalDefeatedScript.skip
	ld a, CERULEANCITY_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	call MoveSprite
	ld a, SCRIPT_CERULEANCITY_RIVAL_CLEANUP
	ld [wCeruleanCityCurScript], a
	ret

CeruleanCityMovement3:
	.DB NPC_MOVEMENT_LEFT
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB -1 ; end

CeruleanCityMovement4:
	.DB NPC_MOVEMENT_RIGHT
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB -1 ; end

CeruleanCityRivalCleanupScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_CERULEAN_RIVAL
	ld [wToggleableObjectIndex], a
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	call PlayDefaultMusic
	ld a, SCRIPT_CERULEANCITY_DEFAULT
	ld [wCeruleanCityCurScript], a
	ret

CeruleanCity_TextPointers:
	def_text_pointers
	dw_const CeruleanCityRivalText,         TEXT_CERULEANCITY_RIVAL
	dw_const CeruleanCityRocketText,        TEXT_CERULEANCITY_ROCKET
	dw_const CeruleanCityCooltrainerMText,  TEXT_CERULEANCITY_COOLTRAINER_M
	dw_const CeruleanCitySuperNerd1Text,    TEXT_CERULEANCITY_SUPER_NERD1
	dw_const CeruleanCitySuperNerd2Text,    TEXT_CERULEANCITY_SUPER_NERD2
	dw_const CeruleanCityGuardText,         TEXT_CERULEANCITY_GUARD1
	dw_const CeruleanCityCooltrainerF1Text, TEXT_CERULEANCITY_COOLTRAINER_F1
	dw_const CeruleanCitySlowbroText,       TEXT_CERULEANCITY_SLOWBRO
	dw_const CeruleanCityCooltrainerF2Text, TEXT_CERULEANCITY_COOLTRAINER_F2
	dw_const CeruleanCitySuperNerd3Text,    TEXT_CERULEANCITY_SUPER_NERD3
	dw_const CeruleanCityGuardText,         TEXT_CERULEANCITY_GUARD2
	dw_const CeruleanCitySignText,          TEXT_CERULEANCITY_SIGN
	dw_const CeruleanCityTrainerTipsText,   TEXT_CERULEANCITY_TRAINER_TIPS
	dw_const MartSignText,                  TEXT_CERULEANCITY_MART_SIGN
	dw_const PokeCenterSignText,            TEXT_CERULEANCITY_POKECENTER_SIGN
	dw_const CeruleanCityBikeShopSign,      TEXT_CERULEANCITY_BIKESHOP_SIGN
	dw_const CeruleanCityGymSign,           TEXT_CERULEANCITY_GYM_SIGN

CeruleanCityRivalText:
	text_asm
	CheckEvent EVENT_BEAT_CERULEAN_RIVAL
	; do pre-battle text
	jr z, CeruleanCityRivalText.PreBattle
	; or talk about bill
	ld hl, CeruleanCityRivalIWentToBillsText
	call PrintText
	jr CeruleanCityRivalText.end
CeruleanCityRivalText.PreBattle
	ld hl, CeruleanCityRivalText.PreBattleText
	call PrintText
CeruleanCityRivalText.end
	jp TextScriptEnd

CeruleanCityRivalText.PreBattleText:
	text_far WLA_GLOBAL_CeruleanCityRivalPreBattleText
	text_end

CeruleanCityRivalDefeatedText:
	text_far WLA_GLOBAL_CeruleanCityRivalDefeatedText
	text_end

CeruleanCityRivalVictoryText:
	text_far WLA_GLOBAL_CeruleanCityRivalVictoryText
	text_end

CeruleanCityRivalIWentToBillsText:
	text_far WLA_GLOBAL_CeruleanCityRivalIWentToBillsText
	text_end

CeruleanCityRocketText:
	text_asm
	CheckEvent EVENT_BEAT_CERULEAN_ROCKET_THIEF
	jr nz, CeruleanCityRocketText.beatRocketThief
	ld hl, CeruleanCityRocketText.Text
	call PrintText
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, CeruleanCityRocketText.IGiveUpText
	ld de, CeruleanCityRocketText.IGiveUpText
	call SaveEndBattleTextPointers
	ldh a, [lobyte(hTextID)]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, SCRIPT_CERULEANCITY_ROCKET_DEFEATED
	ld [wCeruleanCityCurScript], a
	jp TextScriptEnd
CeruleanCityRocketText.beatRocketThief
	ld hl, CeruleanCityRocketText.IllReturnTheTMText
	call PrintText
	lb "bc", TM_DIG, 1
	call GiveItem
	jr c, CeruleanCityRocketText.Success
	ld hl, CeruleanCityRocketText.TM28NoRoomText
	call PrintText
	jr CeruleanCityRocketText.Done
CeruleanCityRocketText.Success
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CeruleanCityRocketText.ReceivedTM28Text
	call PrintText
	farcall CeruleanHideRocket
CeruleanCityRocketText.Done
	jp TextScriptEnd

CeruleanCityRocketText.Text:
	text_far WLA_GLOBAL_CeruleanCityRocketText
	text_end

CeruleanCityRocketText.ReceivedTM28Text:
	text_far WLA_GLOBAL_CeruleanCityRocketReceivedTM28Text
	sound_get_item_1
	text_far WLA_GLOBAL_CeruleanCityRocketIBetterGetMovingText
	text_waitbutton
	text_end

CeruleanCityRocketText.TM28NoRoomText:
	text_far WLA_GLOBAL_CeruleanCityRocketTM28NoRoomText
	text_end

CeruleanCityRocketText.IGiveUpText:
	text_far WLA_GLOBAL_CeruleanCityRocketIGiveUpText
	text_end

CeruleanCityRocketText.IllReturnTheTMText:
	text_far WLA_GLOBAL_CeruleanCityRocketIllReturnTheTMText
	text_end

CeruleanCityCooltrainerMText:
	text_far WLA_GLOBAL_CeruleanCityCooltrainerMText
	text_end

CeruleanCitySuperNerd1Text:
	text_far WLA_GLOBAL_CeruleanCitySuperNerd1Text
	text_end

CeruleanCitySuperNerd2Text:
	text_far WLA_GLOBAL_CeruleanCitySuperNerd2Text
	text_end

CeruleanCityGuardText:
	text_far WLA_GLOBAL_CeruleanCityGuardText
	text_end

CeruleanCityCooltrainerF1Text:
	text_asm
	ldh a, [lobyte(hRandomAdd)]
	cp 180 ; 76/256 chance of 1st dialogue
	jr c, CeruleanCityCooltrainerF1Text.notFirstText
	ld hl, CeruleanCityCooltrainerF1Text.SlowbroUseSonicboomText
	call PrintText
	jr CeruleanCityCooltrainerF1Text.end
CeruleanCityCooltrainerF1Text.notFirstText
	cp 100 ; 80/256 chance of 2nd dialogue
	jr c, CeruleanCityCooltrainerF1Text.notSecondText
	ld hl, CeruleanCityCooltrainerF1Text.SlowbroPunchText
	call PrintText
	jr CeruleanCityCooltrainerF1Text.end
CeruleanCityCooltrainerF1Text.notSecondText
	; 100/256 chance of 3rd dialogue
	ld hl, CeruleanCityCooltrainerF1Text.SlowbroWithdrawText
	call PrintText
CeruleanCityCooltrainerF1Text.end
	jp TextScriptEnd

CeruleanCityCooltrainerF1Text.SlowbroUseSonicboomText:
	text_far WLA_GLOBAL_CeruleanCityCooltrainerF1SlowbroUseSonicboomText
	text_end

CeruleanCityCooltrainerF1Text.SlowbroPunchText:
	text_far WLA_GLOBAL_CeruleanCityCooltrainerF1SlowbroPunchText
	text_end

CeruleanCityCooltrainerF1Text.SlowbroWithdrawText:
	text_far WLA_GLOBAL_CeruleanCityCooltrainerF1SlowbroWithdrawText
	text_end

CeruleanCitySlowbroText:
	text_asm
	ldh a, [lobyte(hRandomAdd)]
	cp 180 ; 76/256 chance of 1st dialogue
	jr c, CeruleanCitySlowbroText.notFirstText
	ld hl, CeruleanCitySlowbroText.TookASnoozeText
	call PrintText
	jr CeruleanCitySlowbroText.end
CeruleanCitySlowbroText.notFirstText
	cp 120 ; 60/256 chance of 2nd dialogue
	jr c, CeruleanCitySlowbroText.notSecondText
	ld hl, CeruleanCitySlowbroText.IsLoafingAroundText
	call PrintText
	jr CeruleanCitySlowbroText.end
CeruleanCitySlowbroText.notSecondText
	cp 60 ; 60/256 chance of 3rd dialogue
	jr c, CeruleanCitySlowbroText.notThirdText
	ld hl, CeruleanCitySlowbroText.TurnedAwayText
	call PrintText
	jr CeruleanCitySlowbroText.end
CeruleanCitySlowbroText.notThirdText
	; 60/256 chance of 4th dialogue
	ld hl, CeruleanCitySlowbroText.IgnoredOrdersText
	call PrintText
CeruleanCitySlowbroText.end
	jp TextScriptEnd

CeruleanCitySlowbroText.TookASnoozeText:
	text_far WLA_GLOBAL_CeruleanCitySlowbroTookASnoozeText
	text_end

CeruleanCitySlowbroText.IsLoafingAroundText:
	text_far WLA_GLOBAL_CeruleanCitySlowbroIsLoafingAroundText
	text_end

CeruleanCitySlowbroText.TurnedAwayText:
	text_far WLA_GLOBAL_CeruleanCitySlowbroTurnedAwayText
	text_end

CeruleanCitySlowbroText.IgnoredOrdersText:
	text_far WLA_GLOBAL_CeruleanCitySlowbroIgnoredOrdersText
	text_end

CeruleanCityCooltrainerF2Text:
	text_far WLA_GLOBAL_CeruleanCityCooltrainerF2Text
	text_end

CeruleanCitySuperNerd3Text:
	text_far WLA_GLOBAL_CeruleanCitySuperNerd3Text
	text_end

CeruleanCitySignText:
	text_far WLA_GLOBAL_CeruleanCitySignText
	text_end

CeruleanCityTrainerTipsText:
	text_far WLA_GLOBAL_CeruleanCityTrainerTipsText
	text_end

CeruleanCityBikeShopSign:
	text_far WLA_GLOBAL_CeruleanCityBikeShopSign
	text_end

CeruleanCityGymSign:
	text_far WLA_GLOBAL_CeruleanCityGymSign
	text_end
