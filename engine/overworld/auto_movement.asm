PlayerStepOutFromDoor:
	ld hl, wStatusFlags5
	res BIT_UNKNOWN_5_1, [hl]
	call IsPlayerStandingOnDoorTile
	jr nc, PlayerStepOutFromDoor.notStandingOnDoor
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld hl, wMovementFlags
	set BIT_EXITING_DOOR, [hl]
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, PAD_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1ImageIndex], a
	call StartSimulatingJoypadStates
	ret
PlayerStepOutFromDoor.notStandingOnDoor
	xor a
	ld [wUnusedOverrideSimulatedJoypadStatesIndex], a
	ld [wSimulatedJoypadStatesIndex], a
	ld [wSimulatedJoypadStatesEnd], a
	ld hl, wMovementFlags
	res BIT_STANDING_ON_DOOR, [hl]
	res BIT_EXITING_DOOR, [hl]
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ret

_EndNPCMovementScript:
WLA_GLOBAL_EndNPCMovementScript:
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	ld hl, wMovementFlags
	res BIT_STANDING_ON_DOOR, [hl]
	res BIT_EXITING_DOOR, [hl]
	xor a
	ld [wNPCMovementScriptSpriteOffset], a
	ld [wNPCMovementScriptPointerTableNum], a
	ld [wNPCMovementScriptFunctionNum], a
	ld [wUnusedOverrideSimulatedJoypadStatesIndex], a
	ld [wSimulatedJoypadStatesIndex], a
	ld [wSimulatedJoypadStatesEnd], a
	ret

PalletMovementScriptPointerTable:
	.DW PalletMovementScript_OakMoveLeft
	.DW PalletMovementScript_PlayerMoveLeft
	.DW PalletMovementScript_WaitAndWalkToLab
	.DW PalletMovementScript_WalkToLab
	.DW PalletMovementScript_Done

PalletMovementScript_OakMoveLeft:
	ld a, [wXCoord]
	sub $a
	ld [wNumStepsToTake], a
	jr z, PalletMovementScript_OakMoveLeft.playerOnLeftTile
; The player is on the right tile of the northern path out of Pallet Town and
; Prof. Oak is below.
; Make Prof. Oak step to the left.
	ld b, 0
	ld c, a
	ld hl, wNPCMovementDirections2
	ld a, NPC_MOVEMENT_LEFT
	call FillMemory
	ld [hl], $ff
	ld a, [wSpriteIndex]
	ldh [lobyte(hSpriteIndex)], a
	ld de, wNPCMovementDirections2
	call MoveSprite
	ld a, $1
	ld [wNPCMovementScriptFunctionNum], a
	jr PalletMovementScript_OakMoveLeft.done
; The player is on the left tile of the northern path out of Pallet Town and
; Prof. Oak is below.
; Prof. Oak is already where he needs to be.
PalletMovementScript_OakMoveLeft.playerOnLeftTile
	ld a, $3
	ld [wNPCMovementScriptFunctionNum], a
PalletMovementScript_OakMoveLeft.done
	ld hl, wStatusFlags7
	set BIT_NO_MAP_MUSIC, [hl]
	ld a, PAD_SELECT | PAD_START | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ret

PalletMovementScript_PlayerMoveLeft:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz ; return if Oak is still moving
	ld a, [wNumStepsToTake]
	ld [wSimulatedJoypadStatesIndex], a
	ldh [lobyte(hNPCMovementDirections2Index)], a
	predef ConvertNPCMovementDirectionsToJoypadMasks
	call StartSimulatingJoypadStates
	ld a, $2
	ld [wNPCMovementScriptFunctionNum], a
	ret

PalletMovementScript_WaitAndWalkToLab:
	ld a, [wSimulatedJoypadStatesIndex]
	and a ; is the player done moving left yet?
	ret nz

PalletMovementScript_WalkToLab:
	xor a
	ld [wOverrideSimulatedJoypadStatesMask], a
	ld a, [wSpriteIndex]
	swap a
	ld [wNPCMovementScriptSpriteOffset], a
	xor a
	ld [wSpritePlayerStateData2MovementByte1], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEList_PlayerWalkToLab
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	ld hl, wNPCMovementDirections2
	ld de, RLEList_ProfOakWalkToLab
	call DecodeRLEList
	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	ld hl, wStatusFlags5
	set BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld a, $4
	ld [wNPCMovementScriptFunctionNum], a
	ret

RLEList_ProfOakWalkToLab:
	.DB NPC_MOVEMENT_DOWN, 5
	.DB NPC_MOVEMENT_LEFT, 1
	.DB NPC_MOVEMENT_DOWN, 5
	.DB NPC_MOVEMENT_RIGHT, 3
	.DB NPC_MOVEMENT_UP, 1
	.DB NPC_CHANGE_FACING, 1
	.DB -1 ; end

RLEList_PlayerWalkToLab:
	.DB PAD_UP, 2
	.DB PAD_RIGHT, 3
	.DB PAD_DOWN, 5
	.DB PAD_LEFT, 1
	.DB PAD_DOWN, 6
	.DB -1 ; end

PalletMovementScript_Done:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, TOGGLE_PALLET_TOWN_OAK
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	jp EndNPCMovementScript

PewterMuseumGuyMovementScriptPointerTable:
	.DW PewterMovementScript_WalkToMuseum
	.DW PewterMovementScript_Done

PewterMovementScript_WalkToMuseum:
	ld a, bank(Music_MuseumGuy)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, MUSIC_MUSEUM_GUY
	ld [wNewSoundID], a
	call PlaySound
	ld a, [wSpriteIndex]
	swap a
	ld [wNPCMovementScriptSpriteOffset], a
	call StartSimulatingJoypadStates
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEList_PewterMuseumPlayer
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	xor a
	ld [wWhichPewterGuy], a
	predef PewterGuys
	ld hl, wNPCMovementDirections2
	ld de, RLEList_PewterMuseumGuy
	call DecodeRLEList
	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	ld a, $1
	ld [wNPCMovementScriptFunctionNum], a
	ret

RLEList_PewterMuseumPlayer:
	.DB NO_INPUT, 1
	.DB PAD_UP, 3
	.DB PAD_LEFT, 13
	.DB PAD_UP, 6
	.DB -1 ; end

RLEList_PewterMuseumGuy:
	.DB NPC_MOVEMENT_UP, 6
	.DB NPC_MOVEMENT_LEFT, 13
	.DB NPC_MOVEMENT_UP, 3
	.DB NPC_MOVEMENT_LEFT, 1
	.DB -1 ; end

PewterMovementScript_Done:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	jp EndNPCMovementScript

PewterGymGuyMovementScriptPointerTable:
	.DW PewterMovementScript_WalkToGym
	.DW PewterMovementScript_Done

PewterMovementScript_WalkToGym:
	ld a, bank(Music_MuseumGuy)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, MUSIC_MUSEUM_GUY
	ld [wNewSoundID], a
	call PlaySound
	ld a, [wSpriteIndex]
	swap a
	ld [wNPCMovementScriptSpriteOffset], a
	xor a
	ld [wSpritePlayerStateData2MovementByte1], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEList_PewterGymPlayer
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	ld a, 1
	ld [wWhichPewterGuy], a
	predef PewterGuys
	ld hl, wNPCMovementDirections2
	ld de, RLEList_PewterGymGuy
	call DecodeRLEList
	ld hl, wStatusFlags4
	res BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	ld hl, wStatusFlags5
	set BIT_SCRIPTED_MOVEMENT_STATE, [hl]
	ld a, $1
	ld [wNPCMovementScriptFunctionNum], a
	ret

RLEList_PewterGymPlayer:
	.DB NO_INPUT, 1
	.DB PAD_RIGHT, 2
	.DB PAD_DOWN, 5
	.DB PAD_LEFT, 11
	.DB PAD_UP, 5
	.DB PAD_LEFT, 15
	.DB -1 ; end

RLEList_PewterGymGuy:
	.DB NPC_MOVEMENT_DOWN, 2
	.DB NPC_MOVEMENT_LEFT, 15
	.DB NPC_MOVEMENT_UP, 5
	.DB NPC_MOVEMENT_LEFT, 11
	.DB NPC_MOVEMENT_DOWN, 5
	.DB NPC_MOVEMENT_RIGHT, 3
	.DB -1 ; end

SetEnemyTrainerToStayAndFaceAnyDirection:
	ld a, [wCurMap]
	cp POKEMON_TOWER_7F
	ret z ; the Rockets on Pokemon Tower 7F leave after battling, so don't set them
	ld hl, RivalIDs
	ld a, [wEngagedTrainerClass]
	ld b, a
SetEnemyTrainerToStayAndFaceAnyDirection.loop
	ld a, [hli]
	cp -1
	jr z, SetEnemyTrainerToStayAndFaceAnyDirection.notRival
	cp b
	ret z ; the rival leaves after battling, so don't set him
	jr SetEnemyTrainerToStayAndFaceAnyDirection.loop
SetEnemyTrainerToStayAndFaceAnyDirection.notRival
	ld a, [wSpriteIndex]
	ldh [lobyte(hSpriteIndex)], a
	jp SetSpriteMovementBytesToFF

RivalIDs:
	.DB OPP_RIVAL1
	.DB OPP_RIVAL2
	.DB OPP_RIVAL3
	.DB -1 ; end
