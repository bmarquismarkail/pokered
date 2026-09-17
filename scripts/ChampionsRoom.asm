ChampionsRoom_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ChampionsRoom_ScriptPointers
	ld a, [wChampionsRoomCurScript]
	jp CallFunctionInTable

ResetRivalScript:
	xor a ; SCRIPT_CHAMPIONSROOM_DEFAULT
	ld [wJoyIgnore], a
	ld [wChampionsRoomCurScript], a
	ret

ChampionsRoom_ScriptPointers:
	def_script_pointers
	dw_const ChampionsRoomDefaultScript,                  SCRIPT_CHAMPIONSROOM_DEFAULT
	dw_const ChampionsRoomPlayerEntersScript,             SCRIPT_CHAMPIONSROOM_PLAYER_ENTERS
	dw_const ChampionsRoomRivalReadyToBattleScript,       SCRIPT_CHAMPIONSROOM_RIVAL_READY_TO_BATTLE
	dw_const ChampionsRoomRivalDefeatedScript,            SCRIPT_CHAMPIONSROOM_RIVAL_DEFEATED
	dw_const ChampionsRoomOakArrivesScript,               SCRIPT_CHAMPIONSROOM_OAK_ARRIVES
	dw_const ChampionsRoomOakCongratulatesPlayerScript,   SCRIPT_CHAMPIONSROOM_OAK_CONGRATULATES_PLAYER
	dw_const ChampionsRoomOakDisappointedWithRivalScript, SCRIPT_CHAMPIONSROOM_OAK_DISAPPOINTED_WITH_RIVAL
	dw_const ChampionsRoomOakComeWithMeScript,            SCRIPT_CHAMPIONSROOM_OAK_COME_WITH_ME
	dw_const ChampionsRoomOakExitsScript,                 SCRIPT_CHAMPIONSROOM_OAK_EXITS
	dw_const ChampionsRoomPlayerFollowsOakScript,         SCRIPT_CHAMPIONSROOM_PLAYER_FOLLOWS_OAK
	dw_const ChampionsRoomCleanupScript,                  SCRIPT_CHAMPIONSROOM_CLEANUP_SCRIPT

ChampionsRoomDefaultScript:
	ret

ChampionsRoomPlayerEntersScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RivalEntrance_RLEMovement
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, SCRIPT_CHAMPIONSROOM_RIVAL_READY_TO_BATTLE
	ld [wChampionsRoomCurScript], a
	ret

RivalEntrance_RLEMovement:
	.DB PAD_UP, 1
	.DB PAD_RIGHT, 1
	.DB PAD_UP, 3
	.DB -1 ; end

ChampionsRoomRivalReadyToBattleScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld hl, wOptions
	res BIT_BATTLE_ANIMATION, [hl]
	ld a, TEXT_CHAMPIONSROOM_RIVAL
	ldh [lobyte(hTextID)], a
	call DisplayTextID
	call Delay3
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, RivalDefeatedText
	ld de, RivalVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_RIVAL3
	ld [wCurOpponent], a

	; select which team to use during the encounter
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, ChampionsRoomRivalReadyToBattleScript.NotStarter2
	ld a, $1
	jr ChampionsRoomRivalReadyToBattleScript.saveTrainerId
ChampionsRoomRivalReadyToBattleScript.NotStarter2
	cp STARTER3
	jr nz, ChampionsRoomRivalReadyToBattleScript.NotStarter3
	ld a, $2
	jr ChampionsRoomRivalReadyToBattleScript.saveTrainerId
ChampionsRoomRivalReadyToBattleScript.NotStarter3
	ld a, $3
ChampionsRoomRivalReadyToBattleScript.saveTrainerId
	ld [wTrainerNo], a

	xor a
	ldh [lobyte(hJoyHeld)], a
	ld a, SCRIPT_CHAMPIONSROOM_RIVAL_DEFEATED
	ld [wChampionsRoomCurScript], a
	ret

ChampionsRoomRivalDefeatedScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ResetRivalScript
	call UpdateSprites
	SetEvent EVENT_BEAT_CHAMPION_RIVAL
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld a, TEXT_CHAMPIONSROOM_RIVAL
	ldh [lobyte(hTextID)], a
	call ChampionsRoom_DisplayTextID_AllowABSelectStart
	ld a, CHAMPIONSROOM_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	call SetSpriteMovementBytesToFF
	ld a, SCRIPT_CHAMPIONSROOM_OAK_ARRIVES
	ld [wChampionsRoomCurScript], a
	ret

ChampionsRoomOakArrivesScript:
	farcall Music_Cities1AlternateTempo
	ld a, TEXT_CHAMPIONSROOM_OAK
	ldh [lobyte(hTextID)], a
	call ChampionsRoom_DisplayTextID_AllowABSelectStart
	ld a, CHAMPIONSROOM_OAK
	ldh [lobyte(hSpriteIndex)], a
	call SetSpriteMovementBytesToFF
	ld de, OakEntranceAfterVictoryMovement
	ld a, CHAMPIONSROOM_OAK
	ldh [lobyte(hSpriteIndex)], a
	call MoveSprite
	ld a, TOGGLE_CHAMPIONS_ROOM_OAK
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ld a, SCRIPT_CHAMPIONSROOM_OAK_CONGRATULATES_PLAYER
	ld [wChampionsRoomCurScript], a
	ret

OakEntranceAfterVictoryMovement:
	.DB NPC_MOVEMENT_UP
	.DB NPC_MOVEMENT_UP
	.DB NPC_MOVEMENT_UP
	.DB NPC_MOVEMENT_UP
	.DB NPC_MOVEMENT_UP
	.DB -1 ; end

ChampionsRoomOakCongratulatesPlayerScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, CHAMPIONSROOM_RIVAL
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITE_FACING_LEFT
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, CHAMPIONSROOM_OAK
	ldh [lobyte(hSpriteIndex)], a
	xor a ; SPRITE_FACING_DOWN
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_CHAMPIONSROOM_OAK_CONGRATULATES_PLAYER
	ldh [lobyte(hTextID)], a
	call ChampionsRoom_DisplayTextID_AllowABSelectStart
	ld a, SCRIPT_CHAMPIONSROOM_OAK_DISAPPOINTED_WITH_RIVAL
	ld [wChampionsRoomCurScript], a
	ret

ChampionsRoomOakDisappointedWithRivalScript:
	ld a, CHAMPIONSROOM_OAK
	ldh [lobyte(hSpriteIndex)], a
	ld a, SPRITE_FACING_RIGHT
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_CHAMPIONSROOM_OAK_DISAPPOINTED_WITH_RIVAL
	ldh [lobyte(hTextID)], a
	call ChampionsRoom_DisplayTextID_AllowABSelectStart
	ld a, SCRIPT_CHAMPIONSROOM_OAK_COME_WITH_ME
	ld [wChampionsRoomCurScript], a
	ret

ChampionsRoomOakComeWithMeScript:
	ld a, CHAMPIONSROOM_OAK
	ldh [lobyte(hSpriteIndex)], a
	xor a ; SPRITE_FACING_DOWN
	ldh [lobyte(hSpriteFacingDirection)], a
	call SetSpriteFacingDirectionAndDelay
	ld a, TEXT_CHAMPIONSROOM_OAK_COME_WITH_ME
	ldh [lobyte(hTextID)], a
	call ChampionsRoom_DisplayTextID_AllowABSelectStart
	ld de, OakExitChampionsRoomMovement
	ld a, CHAMPIONSROOM_OAK
	ldh [lobyte(hSpriteIndex)], a
	call MoveSprite
	ld a, SCRIPT_CHAMPIONSROOM_OAK_EXITS
	ld [wChampionsRoomCurScript], a
	ret

OakExitChampionsRoomMovement:
	.DB NPC_MOVEMENT_UP
	.DB NPC_MOVEMENT_UP
	.DB -1 ; end

ChampionsRoomOakExitsScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld a, TOGGLE_CHAMPIONS_ROOM_OAK
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, SCRIPT_CHAMPIONSROOM_PLAYER_FOLLOWS_OAK
	ld [wChampionsRoomCurScript], a
	ret

ChampionsRoomPlayerFollowsOakScript:
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, WalkToHallOfFame_RLEMovement
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, SCRIPT_CHAMPIONSROOM_CLEANUP_SCRIPT
	ld [wChampionsRoomCurScript], a
	ret

WalkToHallOfFame_RLEMovement:
	.DB PAD_UP, 4
	.DB PAD_LEFT, 1
	.DB -1 ; end

ChampionsRoomCleanupScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, SCRIPT_CHAMPIONSROOM_DEFAULT
	ld [wChampionsRoomCurScript], a
	ret

ChampionsRoom_DisplayTextID_AllowABSelectStart:
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	call DisplayTextID
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ret

ChampionsRoom_TextPointers:
	def_text_pointers
	dw_const ChampionsRoomRivalText,                    TEXT_CHAMPIONSROOM_RIVAL
	dw_const ChampionsRoomOakText,                      TEXT_CHAMPIONSROOM_OAK
	dw_const ChampionsRoomOakCongratulatesPlayerText,   TEXT_CHAMPIONSROOM_OAK_CONGRATULATES_PLAYER
	dw_const ChampionsRoomOakDisappointedWithRivalText, TEXT_CHAMPIONSROOM_OAK_DISAPPOINTED_WITH_RIVAL
	dw_const ChampionsRoomOakComeWithMeText,            TEXT_CHAMPIONSROOM_OAK_COME_WITH_ME

ChampionsRoomRivalText:
	text_asm
	CheckEvent EVENT_BEAT_CHAMPION_RIVAL
	ld hl, ChampionsRoomRivalText.IntroText
	jr z, ChampionsRoomRivalText.printText
	ld hl, ChampionsRoomRivalAfterBattleText
ChampionsRoomRivalText.printText
	call PrintText
	jp TextScriptEnd

ChampionsRoomRivalText.IntroText:
	text_far WLA_GLOBAL_ChampionsRoomRivalIntroText
	text_end

RivalDefeatedText:
	text_far WLA_GLOBAL_RivalDefeatedText
	text_end

RivalVictoryText:
	text_far WLA_GLOBAL_RivalVictoryText
	text_end

ChampionsRoomRivalAfterBattleText:
	text_far WLA_GLOBAL_ChampionsRoomRivalAfterBattleText
	text_end

ChampionsRoomOakText:
	text_far WLA_GLOBAL_ChampionsRoomOakText
	text_end

ChampionsRoomOakCongratulatesPlayerText:
	text_asm
	ld a, [wPlayerStarter]
	ld [wNamedObjectIndex], a
	call GetMonName
	ld hl, ChampionsRoomOakCongratulatesPlayerText.Text
	call PrintText
	jp TextScriptEnd

ChampionsRoomOakCongratulatesPlayerText.Text:
	text_far WLA_GLOBAL_ChampionsRoomOakCongratulatesPlayerText
	text_end

ChampionsRoomOakDisappointedWithRivalText:
	text_far WLA_GLOBAL_ChampionsRoomOakDisappointedWithRivalText
	text_end

ChampionsRoomOakComeWithMeText:
	text_far WLA_GLOBAL_ChampionsRoomOakComeWithMeText
	text_end
