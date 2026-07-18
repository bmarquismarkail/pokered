AgathasRoom_h:
	.DB $0F,$06,$05
	.DW AgathasRoom_Blocks
	.DW AgathasRoom_TextPointers
	.DW AgathasRoom_Script
	.DB $00
	.DW AgathasRoom_Object
AgathasRoomHeaderEnd:
.ASSERT AgathasRoomHeaderEnd - AgathasRoom_h == 12

AgathasRoom_Script:
	CALL AgathaShowOrHideExitBlock
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD HL, AgathasRoomTrainerHeaders
	LD DE, AgathasRoom_ScriptPointers
	LD A, ($D64F) ; wAgathasRoomCurScript
	CALL $3160 ; ExecuteCurMapScriptInTable
	LD ($D64F), A
	RET
AgathasRoomScriptEnd:
.ASSERT AgathasRoomScriptEnd - AgathasRoom_Script == 22

AgathaShowOrHideExitBlock:
	LD HL, $D126 ; wCurrentMapScriptFlags
	BIT 5, (HL) ; BIT_CUR_MAP_LOADED_1
	RES 5, (HL)
	RET Z
	LD A, ($D865)
	BIT 1, A ; EVENT_BEAT_AGATHAS_ROOM_TRAINER_0
	JR Z, AgathaShowOrHideExitBlock.blockExit
	LD A, $0E
	JP AgathaShowOrHideExitBlock.setExitBlock
AgathaShowOrHideExitBlock.blockExit:
	LD A, $3B
AgathaShowOrHideExitBlock.setExitBlock:
	LD ($D09F), A ; wNewTileBlockID
	LD BC, $0002
	LD A, $17 ; ReplaceTileBlock predef
	JP $3E6D ; Predef
AgathaShowOrHideExitBlockEnd:
.ASSERT AgathaShowOrHideExitBlockEnd - AgathaShowOrHideExitBlock == 33

ResetAgathaScript:
	XOR A
	LD ($D64F), A
	RET
ResetAgathaScriptEnd:
.ASSERT ResetAgathaScriptEnd - ResetAgathaScript == 5

AgathasRoom_ScriptPointers:
	.DW AgathasRoomDefaultScript,$324C,AgathasRoomAgathaEndBattleScript
	.DW AgathasRoomPlayerIsMovingScript,AgathasRoomNoopScript
AgathasRoomScriptPointersEnd:
.ASSERT AgathasRoomScriptPointersEnd - AgathasRoom_ScriptPointers == 10

AgathasRoomNoopScript:
	RET
AgathasRoomNoopEnd:
.ASSERT AgathasRoomNoopEnd - AgathasRoomNoopScript == 1

AgathaScriptWalkIntoRoom:
	LD HL, $CCD3 ; wSimulatedJoypadStatesEnd
	LD A, $40 ; PAD_UP
	LD (HL+), A
	LD (HL+), A
	LD (HL+), A
	LD (HL+), A
	LD (HL+), A
	LD (HL), A
	LD A, 6
	LD ($CD38), A ; wSimulatedJoypadStatesIndex
	CALL $3486 ; StartSimulatingJoypadStates
	LD A, 3 ; SCRIPT_AGATHASROOM_PLAYER_IS_MOVING
	LD ($D64F), A
	LD ($DA39), A ; wCurMapScript
	RET
AgathaScriptWalkIntoRoomEnd:
.ASSERT AgathaScriptWalkIntoRoomEnd - AgathaScriptWalkIntoRoom == 28
