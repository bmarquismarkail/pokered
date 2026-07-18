LoreleiScriptWalkIntoRoom:
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
	LD A, 3 ; SCRIPT_LORELEISROOM_PLAYER_IS_MOVING
	LD ($D64D), A
	LD ($DA39), A ; wCurMapScript
	RET
LoreleiScriptWalkIntoRoomEnd:
.ASSERT LoreleiScriptWalkIntoRoomEnd - LoreleiScriptWalkIntoRoom == 28

LoreleisRoomDefaultScript:
	LD HL, LoreleiEntranceCoords
	CALL $34BF ; ArePlayerCoordsInArray
	JP NC, $3219 ; CheckFightingMapTrainers
	XOR A
	LDH ($B3), A ; hJoyPressed
	LDH ($B4), A ; hJoyHeld
	LD ($CCD3), A ; wSimulatedJoypadStatesEnd
	LD ($CD38), A
	LD A, ($CD3D) ; wCoordIndex
	CP 3
	JR C, LoreleisRoomDefaultScript.stopPlayer
	LD HL, $D863
	BIT 6, (HL) ; EVENT_AUTOWALKED_INTO_LORELEIS_ROOM
	SET 6, (HL)
	JR Z, LoreleiScriptWalkIntoRoom
LoreleisRoomDefaultScript.stopPlayer:
	LD A, 2 ; TEXT_LORELEISROOM_DONT_RUN_AWAY
	LDH ($8C), A
	CALL $2920 ; DisplayTextID
	LD A, $40
	LD ($CCD3), A
	LD A, 1
	LD ($CD38), A
	CALL $3486
	LD A, 3
	LD ($D64D), A
	LD ($DA39), A
	RET
LoreleisRoomDefaultEnd:
.ASSERT LoreleisRoomDefaultEnd - LoreleisRoomDefaultScript == 65

LoreleiEntranceCoords:
	.DB $0A,$04,$0A,$05,$0B,$04,$0B,$05,$FF
LoreleiEntranceCoordsEnd:
.ASSERT LoreleiEntranceCoordsEnd - LoreleiEntranceCoords == 9

LoreleisRoomPlayerIsMovingScript:
	LD A, ($CD38)
	AND A
	RET NZ
	CALL $3DD7 ; Delay3
	XOR A
	LD ($CD6B), A ; wJoyIgnore
	LD ($D64D), A
	LD ($DA39), A
	RET
LoreleisRoomPlayerMovingEnd:
.ASSERT LoreleisRoomPlayerMovingEnd - LoreleisRoomPlayerIsMovingScript == 19

LoreleisRoomLoreleiEndBattleScript:
	CALL $3275 ; EndTrainerBattle
	LD A, ($D057) ; wIsInBattle
	CP $FF
	JP Z, ResetLoreleiScript
	LD A, 1 ; TEXT_LORELEISROOM_LORELEI
	LDH ($8C), A
	JP $2920 ; DisplayTextID
LoreleisRoomEndBattleEnd:
.ASSERT LoreleisRoomEndBattleEnd - LoreleisRoomLoreleiEndBattleScript == 18
