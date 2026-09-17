SilphCo11F_Script:
	call SilphCo11FGateCallbackScript
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo11TrainerHeaders
	ld de, SilphCo11F_ScriptPointers
	ld a, [wSilphCo11FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo11FCurScript], a
	ret

SilphCo11FGateCallbackScript:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	ld hl, SilphCo11GateCoords
	call SilphCo11F_SetCardKeyDoorYScript
	call SilphCo11FSetUnlockedDoorEventScript
	CheckEvent EVENT_SILPH_CO_11_UNLOCKED_DOOR
	ret nz
	ld a, $20
	ld [wNewTileBlockID], a
	lb "bc", 6, 3
	predef_jump ReplaceTileBlock

SilphCo11GateCoords:
	dbmapcoord  3,  6
	.DB -1 ; end

SilphCo11F_SetCardKeyDoorYScript:
	push hl
	ld hl, wCardKeyDoorY
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	xor a
	ldh [lobyte(hUnlockedSilphCoDoors)], a
	pop hl
SilphCo11F_SetCardKeyDoorYScript.loop_check_doors
	ld a, [hli]
	cp $ff
	jr z, SilphCo11F_SetCardKeyDoorYScript.exit_loop
	push hl
	ld hl, hUnlockedSilphCoDoors
	inc [hl]
	pop hl
	cp b
	jr z, SilphCo11F_SetCardKeyDoorYScript.check_y_coord
	inc hl
	jr SilphCo11F_SetCardKeyDoorYScript.loop_check_doors
SilphCo11F_SetCardKeyDoorYScript.check_y_coord
	ld a, [hli]
	cp c
	jr nz, SilphCo11F_SetCardKeyDoorYScript.loop_check_doors
	ld hl, wCardKeyDoorY
	xor a
	ld [hli], a
	ld [hl], a
	ret
SilphCo11F_SetCardKeyDoorYScript.exit_loop
	xor a
	ldh [lobyte(hUnlockedSilphCoDoors)], a
	ret

SilphCo11FSetUnlockedDoorEventScript:
	ldh a, [lobyte(hUnlockedSilphCoDoors)]
	and a
	ret z
	SetEvent EVENT_SILPH_CO_11_UNLOCKED_DOOR
	ret

SilphCo11FTeamRocketLeavesScript:
	ld hl, SilphCo11FTeamRocketLeavesScript.HideToggleableObjectIDs
SilphCo11FTeamRocketLeavesScript.hide_loop
	ld a, [hli]
	cp $ff
	jr z, SilphCo11FTeamRocketLeavesScript.done_hiding
	push hl
	ld [wToggleableObjectIndex], a
	predef HideObject
	pop hl
	jr SilphCo11FTeamRocketLeavesScript.hide_loop
SilphCo11FTeamRocketLeavesScript.done_hiding
	ld hl, SilphCo11FTeamRocketLeavesScript.ShowToggleableObjectIDs
SilphCo11FTeamRocketLeavesScript.show_loop
	ld a, [hli]
	cp -1
	ret z
	push hl
	ld [wToggleableObjectIndex], a
	predef ShowObject
	pop hl
	jr SilphCo11FTeamRocketLeavesScript.show_loop

SilphCo11FTeamRocketLeavesScript.ShowToggleableObjectIDs:
	.DB TOGGLE_SAFFRON_CITY_8
	.DB TOGGLE_SAFFRON_CITY_9
	.DB TOGGLE_SAFFRON_CITY_A
	.DB TOGGLE_SAFFRON_CITY_B
	.DB TOGGLE_SAFFRON_CITY_C
	.DB TOGGLE_SAFFRON_CITY_D
	.DB -1 ; end

SilphCo11FTeamRocketLeavesScript.HideToggleableObjectIDs:
	.DB TOGGLE_SAFFRON_CITY_1
	.DB TOGGLE_SAFFRON_CITY_2
	.DB TOGGLE_SAFFRON_CITY_3
	.DB TOGGLE_SAFFRON_CITY_4
	.DB TOGGLE_SAFFRON_CITY_5
	.DB TOGGLE_SAFFRON_CITY_6
	.DB TOGGLE_SAFFRON_CITY_7
	.DB TOGGLE_SAFFRON_CITY_E
	.DB TOGGLE_SAFFRON_CITY_F
	.DB TOGGLE_SILPH_CO_2F_2
	.DB TOGGLE_SILPH_CO_2F_3
	.DB TOGGLE_SILPH_CO_2F_4
	.DB TOGGLE_SILPH_CO_2F_5
	.DB TOGGLE_SILPH_CO_3F_1
	.DB TOGGLE_SILPH_CO_3F_2
	.DB TOGGLE_SILPH_CO_4F_1
	.DB TOGGLE_SILPH_CO_4F_2
	.DB TOGGLE_SILPH_CO_4F_3
	.DB TOGGLE_SILPH_CO_5F_1
	.DB TOGGLE_SILPH_CO_5F_2
	.DB TOGGLE_SILPH_CO_5F_3
	.DB TOGGLE_SILPH_CO_5F_4
	.DB TOGGLE_SILPH_CO_6F_1
	.DB TOGGLE_SILPH_CO_6F_2
	.DB TOGGLE_SILPH_CO_6F_3
	.DB TOGGLE_SILPH_CO_7F_1
	.DB TOGGLE_SILPH_CO_7F_2
	.DB TOGGLE_SILPH_CO_7F_3
	.DB TOGGLE_SILPH_CO_7F_4
	.DB TOGGLE_SILPH_CO_8F_1
	.DB TOGGLE_SILPH_CO_8F_2
	.DB TOGGLE_SILPH_CO_8F_3
	.DB TOGGLE_SILPH_CO_9F_1
	.DB TOGGLE_SILPH_CO_9F_2
	.DB TOGGLE_SILPH_CO_9F_3
	.DB TOGGLE_SILPH_CO_10F_1
	.DB TOGGLE_SILPH_CO_10F_2
	.DB TOGGLE_SILPH_CO_11F_1
	.DB TOGGLE_SILPH_CO_11F_2
	.DB TOGGLE_SILPH_CO_11F_3
	.DB -1 ; end

SilphCo11FResetCurScript:
	xor a
	ld [wJoyIgnore], a
; fallthrough
SilphCo11FSetCurScript:
	ld [wSilphCo11FCurScript], a
	ld [wCurMapScript], a
	ret

SilphCo11F_ScriptPointers:
	def_script_pointers
	dw_const SilphCo11FDefaultScript,               SCRIPT_SILPHCO11F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_SILPHCO11F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_SILPHCO11F_END_BATTLE
	dw_const SilphCo11FGiovanniBattleFacingScript,  SCRIPT_SILPHCO11F_GIOVANNI_FACING
	dw_const SilphCo11FGiovanniStartBattleScript,   SCRIPT_SILPHCO11F_GIOVANNI_START_BATTLE
	dw_const SilphCo11FGiovanniAfterBattleScript,   SCRIPT_SILPHCO11F_GIOVANNI_AFTER_BATTLE

SilphCo11FDefaultScript:
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret nz
	ld hl, SilphCo11FDefaultScript.PlayerCoordsArray
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	ld a, [wCoordIndex]
	ld [wSavedCoordIndex], a
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_SILPHCO11F_GIOVANNI
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	ld a, SILPHCO11F_GIOVANNI
	ldh [lobyte(hSpriteIndex)], a
	call SetSpriteMovementBytesToFF
	ld de, SilphCo11FDefaultScript.GiovanniMovement
	call MoveSprite
	ld a, SCRIPT_SILPHCO11F_GIOVANNI_FACING
	jp SilphCo11FSetCurScript

SilphCo11FDefaultScript.PlayerCoordsArray:
	dbmapcoord  6, 13
	dbmapcoord  7, 12
	.DB -1 ; end

SilphCo11FDefaultScript.GiovanniMovement:
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB NPC_MOVEMENT_DOWN
	.DB -1 ; end

SilphCo11FSetPlayerAndSpriteFacingDirectionScript:
	ld [wPlayerMovingDirection], a
	ld a, SILPHCO11F_GIOVANNI
	ldh [lobyte(hSpriteIndex)], a
	ld a, b
	ldh [lobyte(hSpriteFacingDirection)], a
	jp SetSpriteFacingDirectionAndDelay

SilphCo11FGiovanniAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, SilphCo11FResetCurScript
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, upper-right entry in SilphCo11FDefaultScript.PlayerCoordsArray
	jr z, SilphCo11FGiovanniAfterBattleScript.face_player_up
	ld a, PLAYER_DIR_LEFT
	ld b, SPRITE_FACING_RIGHT
	jr SilphCo11FGiovanniAfterBattleScript.continue
SilphCo11FGiovanniAfterBattleScript.face_player_up
	ld a, PLAYER_DIR_UP
	ld b, SPRITE_FACING_DOWN
SilphCo11FGiovanniAfterBattleScript.continue
	call SilphCo11FSetPlayerAndSpriteFacingDirectionScript
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_SILPHCO11F_GIOVANNI_YOU_RUINED_OUR_PLANS
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	call GBFadeOutToBlack
	call SilphCo11FTeamRocketLeavesScript
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	SetEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	xor a
	ld [wJoyIgnore], a
	jp SilphCo11FSetCurScript

SilphCo11FGiovanniBattleFacingScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, SILPHCO11F_GIOVANNI
	ldh [lobyte(hSpriteIndex)], a
	call SetSpriteMovementBytesToFF
	ld a, [wSavedCoordIndex]
	cp 1 ; index of second, upper-right entry in SilphCo11FDefaultScript.PlayerCoordsArray
	jr z, SilphCo11FGiovanniBattleFacingScript.face_player_up
	ld a, PLAYER_DIR_LEFT
	ld b, SPRITE_FACING_RIGHT
	jr SilphCo11FGiovanniBattleFacingScript.continue
SilphCo11FGiovanniBattleFacingScript.face_player_up
	ld a, PLAYER_DIR_UP
	ld b, SPRITE_FACING_DOWN
SilphCo11FGiovanniBattleFacingScript.continue
	call SilphCo11FSetPlayerAndSpriteFacingDirectionScript
	call Delay3
	ld a, SCRIPT_SILPHCO11F_GIOVANNI_START_BATTLE
	jp SilphCo11FSetCurScript

SilphCo11FGiovanniStartBattleScript:
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, SilphCo10FGiovanniILostAgainText
	ld de, SilphCo10FGiovanniILostAgainText
	call SaveEndBattleTextPointers
	ldh a, [lobyte(hSpriteIndex)]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_SILPHCO11F_GIOVANNI_AFTER_BATTLE
	jp SilphCo11FSetCurScript

SilphCo11F_TextPointers:
	def_text_pointers
	dw_const SilphCo11FSilphPresidentText,            TEXT_SILPHCO11F_SILPH_PRESIDENT
	dw_const SilphCo11FBeautyText,                    TEXT_SILPHCO11F_BEAUTY
	dw_const SilphCo11FGiovanniText,                  TEXT_SILPHCO11F_GIOVANNI
	dw_const SilphCo11FRocket1Text,                   TEXT_SILPHCO11F_ROCKET1
	dw_const SilphCo11FRocket2Text,                   TEXT_SILPHCO11F_ROCKET2
	dw_const SilphCo11FGiovanniYouRuinedOurPlansText, TEXT_SILPHCO11F_GIOVANNI_YOU_RUINED_OUR_PLANS

SilphCo11TrainerHeaders:
	def_trainers 4
SilphCo11TrainerHeader0:
	trainer EVENT_BEAT_SILPH_CO_11F_TRAINER_0, 4, SilphCo11FRocket1BattleText, SilphCo11FRocket1EndBattleText, SilphCo11FRocket1AfterBattleText
SilphCo11TrainerHeader1:
	trainer EVENT_BEAT_SILPH_CO_11F_TRAINER_1, 3, SilphCo11FRocket2BattleText, SilphCo11FRocket2EndBattleText, SilphCo11FRocket2AfterBattleText
	.DB -1 ; end

SilphCo11FSilphPresidentText:
	text_asm
	CheckEvent EVENT_GOT_MASTER_BALL
	jp nz, SilphCo11FSilphPresidentText.got_item
	ld hl, SilphCo11FSilphPresidentText.Text
	call PrintText
	lb "bc", MASTER_BALL, 1
	call GiveItem
	jr nc, SilphCo11FSilphPresidentText.bag_full
	ld hl, SilphCo11FSilphPresidentText.ReceivedMasterBallText
	call PrintText
	SetEvent EVENT_GOT_MASTER_BALL
	jr SilphCo11FSilphPresidentText.done
SilphCo11FSilphPresidentText.bag_full
	ld hl, SilphCo11FSilphPresidentText.NoRoomText
	call PrintText
	jr SilphCo11FSilphPresidentText.done
SilphCo11FSilphPresidentText.got_item
	ld hl, SilphCo11FSilphPresidentText.MasterBallDescriptionText
	call PrintText
SilphCo11FSilphPresidentText.done
	jp TextScriptEnd

SilphCo11FSilphPresidentText.Text:
	text_far WLA_GLOBAL_SilphCo11FSilphPresidentText
	text_end

SilphCo11FSilphPresidentText.ReceivedMasterBallText:
	text_far WLA_GLOBAL_SilphCo11FSilphPresidentReceivedMasterBallText
	sound_get_key_item
	text_end

SilphCo11FSilphPresidentText.MasterBallDescriptionText:
	text_far WLA_GLOBAL_SilphCo11FSilphPresidentMasterBallDescriptionText
	text_end

SilphCo11FSilphPresidentText.NoRoomText:
	text_far WLA_GLOBAL_SilphCo11FSilphPresidentNoRoomText
	text_end

SilphCo11FBeautyText:
	text_far WLA_GLOBAL_SilphCo11FBeautyText
	text_end

SilphCo11FGiovanniText:
	text_far WLA_GLOBAL_SilphCo11FGiovanniText
	text_end

SilphCo11FGiovanniILostAgainText:
SilphCo10FGiovanniILostAgainText:
	text_far WLA_GLOBAL_SilphCo10FGiovanniILostAgainText
	text_end

SilphCo11FGiovanniYouRuinedOurPlansText:
	text_far WLA_GLOBAL_SilphCo11FGiovanniYouRuinedOurPlansText
	text_end

SilphCo11FRocket1Text:
	text_asm
	ld hl, SilphCo11TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo11FRocket1BattleText:
	text_far WLA_GLOBAL_SilphCo11FRocket1BattleText
	text_end

SilphCo11FRocket1EndBattleText:
	text_far WLA_GLOBAL_SilphCo11FRocket1EndBattleText
	text_end

SilphCo11FRocket1AfterBattleText:
	text_far WLA_GLOBAL_SilphCo11FRocket1AfterBattleText
	text_end

SilphCo11FRocket2Text:
	text_asm
	ld hl, SilphCo11TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo11FRocket2BattleText:
	text_far WLA_GLOBAL_SilphCo11FRocket2BattleText
	text_end

SilphCo11FRocket2EndBattleText:
	text_far WLA_GLOBAL_SilphCo11FRocket2EndBattleText
	text_end

SilphCo11FRocket2AfterBattleText:
	text_far WLA_GLOBAL_SilphCo11FRocket2AfterBattleText
	text_end

SilphCo11FPorygonText: ; unreferenced
SilphCo10FPorygonText:
	text_asm
	ld hl, SilphCo10FPorygonText.Text
	call PrintText
	ld a, PORYGON
	call DisplayPokedex
	jp TextScriptEnd

SilphCo11FPorygonText.Text:
SilphCo10FPorygonText.Text:
	text_far WLA_GLOBAL_SilphCo10FPorygonText
	text_end
