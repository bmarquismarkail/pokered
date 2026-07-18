SilphCo9FGateCallbackScript:
	LD HL, $D126 ; wCurrentMapScriptFlags
	BIT 5, (HL) ; BIT_CUR_MAP_LOADED_1
	RES 5, (HL)
	RET Z
	LD HL, SilphCo9FGateCallbackScript.GateCoordinates
	CALL SilphCo9F_SetCardKeyDoorYScript
	CALL SilphCo9F_SetUnlockedSilphCoDoorsScript
	LD A, ($D834)
	BIT 0, A ; EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	JR NZ, SilphCo9FGateCallbackScript.unlock_door1
	PUSH AF
	LD A, $5F
	LD ($D09F), A ; wNewTileBlockID
	LD BC, $0401
	LD A, $17 ; ReplaceTileBlock predef
	CALL $3E6D
	POP AF
SilphCo9FGateCallbackScript.unlock_door1:
	BIT 1, A
	JR NZ, SilphCo9FGateCallbackScript.unlock_door2
	PUSH AF
	LD A, $54
	LD ($D09F), A
	LD BC, $0209
	LD A, $17
	CALL $3E6D
	POP AF
SilphCo9FGateCallbackScript.unlock_door2:
	BIT 2, A
	JR NZ, SilphCo9FGateCallbackScript.unlock_door3
	PUSH AF
	LD A, $54
	LD ($D09F), A
	LD BC, $0509
	LD A, $17
	CALL $3E6D
	POP AF
SilphCo9FGateCallbackScript.unlock_door3:
	BIT 3, A
	RET NZ
	LD A, $5F
	LD ($D09F), A
	LD BC, $0605
	LD A, $17
	JP $3E6D
SilphCo9FGateCallbackScript.GateCoordinates:
	.DB $04,$01, $02,$09, $05,$09, $06,$05, $FF
SilphCo9FGateCallbackEnd:
.ASSERT SilphCo9FGateCallbackEnd - SilphCo9FGateCallbackScript == 102
