LancesRoom_Script:
	call LanceShowOrHideEntranceBlocks
	call EnableAutoTextBoxDrawing
	ld hl, LancesRoomTrainerHeaders
	ld de, LancesRoom_ScriptPointers
	ld a, [wLancesRoomCurScript]
	call ExecuteCurMapScriptInTable
	ld [wLancesRoomCurScript], a
	ret

LanceShowOrHideEntranceBlocks:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	CheckEvent EVENT_LANCES_ROOM_LOCK_DOOR
	jr nz, LanceShowOrHideEntranceBlocks.closeEntrance
	; open entrance
	ld a, $31
	ld b, $32
	jp LanceShowOrHideEntranceBlocks.setEntranceBlocks
LanceShowOrHideEntranceBlocks.closeEntrance
	ld a, $72
	ld b, $73
LanceShowOrHideEntranceBlocks.setEntranceBlocks
; Replaces the tile blocks so the player can't leave.
	push bc
	ld [wNewTileBlockID], a
	lb "bc", 6, 2
	call LanceShowOrHideEntranceBlocks.SetEntranceBlock
	pop bc
	ld a, b
	ld [wNewTileBlockID], a
	lb "bc", 6, 3
LanceShowOrHideEntranceBlocks.SetEntranceBlock:
	predef_jump ReplaceTileBlock

ResetLanceScript:
	xor a ; SCRIPT_LANCESROOM_DEFAULT
	ld [wLancesRoomCurScript], a
	ret

LancesRoom_ScriptPointers:
	def_script_pointers
	dw_const LancesRoomDefaultScript,               SCRIPT_LANCESROOM_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_LANCESROOM_LANCE_START_BATTLE
	dw_const LancesRoomLanceEndBattleScript,        SCRIPT_LANCESROOM_LANCE_END_BATTLE
	dw_const LancesRoomPlayerIsMovingScript,        SCRIPT_LANCESROOM_PLAYER_IS_MOVING
	dw_const LancesRoomNoopScript,                  SCRIPT_LANCESROOM_NOOP

LancesRoomNoopScript:
	ret

LancesRoomDefaultScript:
	CheckEvent EVENT_BEAT_LANCE
	ret nz
	ld hl, LanceTriggerMovementCoords
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ldh [lobyte(hJoyHeld)], a
	ld a, [wCoordIndex]
	cp $3  ; Is player standing next to Lance's sprite?
	jr nc, LancesRoomDefaultScript.notStandingNextToLance
	ld a, TEXT_LANCESROOM_LANCE
	ldh [lobyte(hTextID)], a
	jp DisplayTextID
LancesRoomDefaultScript.notStandingNextToLance
	cp $5  ; Is player standing on the entrance staircase?
	jr z, WalkToLance
	CheckAndSetEvent EVENT_LANCES_ROOM_LOCK_DOOR
	ret nz
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	ld a, SFX_GO_INSIDE
	call PlaySound
	jp LanceShowOrHideEntranceBlocks

LanceTriggerMovementCoords:
	dbmapcoord  5,  1
	dbmapcoord  6,  2
	dbmapcoord  5, 11
	dbmapcoord  6, 11
	dbmapcoord 24, 16
	.DB -1 ; end

LancesRoomLanceEndBattleScript:
	call EndTrainerBattle
	ld a, [wIsInBattle]
	cp $ff
	jp z, ResetLanceScript
	ld a, TEXT_LANCESROOM_LANCE
	ldh [lobyte(hTextID)], a
	jp DisplayTextID

WalkToLance:
; Moves the player down the hallway to Lance's room.
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, WalkToLance_RLEList
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, SCRIPT_LANCESROOM_PLAYER_IS_MOVING
	ld [wLancesRoomCurScript], a
	ld [wCurMapScript], a
	ret

WalkToLance_RLEList:
	.DB PAD_UP, 12
	.DB PAD_LEFT, 12
	.DB PAD_DOWN, 7
	.DB PAD_LEFT, 6
	.DB -1 ; end

LancesRoomPlayerIsMovingScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a ; SCRIPT_LANCESROOM_DEFAULT
	ld [wJoyIgnore], a
	ld [wLancesRoomCurScript], a
	ld [wCurMapScript], a
	ret

LancesRoom_TextPointers:
	def_text_pointers
	dw_const LancesRoomLanceText, TEXT_LANCESROOM_LANCE

LancesRoomTrainerHeaders:
	def_trainers
LancesRoomTrainerHeader0:
	trainer EVENT_BEAT_LANCES_ROOM_TRAINER_0, 0, LancesRoomLanceBeforeBattleText, LancesRoomLanceEndBattleText, LancesRoomLanceAfterBattleText
	.DB -1 ; end

LancesRoomLanceText:
	text_asm
	ld hl, LancesRoomTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

LancesRoomLanceBeforeBattleText:
	text_far WLA_GLOBAL_LancesRoomLanceBeforeBattleText
	text_end

LancesRoomLanceEndBattleText:
	text_far WLA_GLOBAL_LancesRoomLanceEndBattleText
	text_end

LancesRoomLanceAfterBattleText:
	text_far WLA_GLOBAL_LancesRoomLanceAfterBattleText
	text_asm
	SetEvent EVENT_BEAT_LANCE
	jp TextScriptEnd
