BrunoScriptWalkIntoRoom:
	LD HL, $CCD3
	LD A, $40
	LD (HL+), A
	LD (HL+), A
	LD (HL+), A
	LD (HL+), A
	LD (HL+), A
	LD (HL), A
	LD A, 6
	LD ($CD38), A
	CALL $3486
	LD A, 3
	LD ($D64E), A
	LD ($DA39), A
	RET
BrunoScriptWalkIntoRoomEnd:
.ASSERT BrunoScriptWalkIntoRoomEnd - BrunoScriptWalkIntoRoom == 28

BrunosRoomDefaultScript:
	LD HL, BrunoEntranceCoords
	CALL $34BF
	JP NC, $3219
	XOR A
	LDH ($B3), A
	LDH ($B4), A
	LD ($CCD3), A
	LD ($CD38), A
	LD A, ($CD3D)
	CP 3
	JR C, BrunosRoomDefaultScript.stopPlayer
	LD HL, $D864
	BIT 6, (HL) ; EVENT_AUTOWALKED_INTO_BRUNOS_ROOM
	SET 6, (HL)
	JR Z, BrunoScriptWalkIntoRoom
BrunosRoomDefaultScript.stopPlayer:
	LD A, 2
	LDH ($8C), A
	CALL $2920
	LD A, $40
	LD ($CCD3), A
	LD A, 1
	LD ($CD38), A
	CALL $3486
	LD A, 3
	LD ($D64E), A
	LD ($DA39), A
	RET
BrunosRoomDefaultEnd:
.ASSERT BrunosRoomDefaultEnd - BrunosRoomDefaultScript == 65

BrunoEntranceCoords:
	.DB $0A,$04,$0A,$05,$0B,$04,$0B,$05,$FF
BrunoEntranceCoordsEnd:
.ASSERT BrunoEntranceCoordsEnd - BrunoEntranceCoords == 9

BrunosRoomPlayerIsMovingScript:
	LD A, ($CD38)
	AND A
	RET NZ
	CALL $3DD7
	XOR A
	LD ($CD6B), A
	LD ($D64E), A
	LD ($DA39), A
	RET
BrunosRoomPlayerMovingEnd:
.ASSERT BrunosRoomPlayerMovingEnd - BrunosRoomPlayerIsMovingScript == 19

BrunosRoomBrunoEndBattleScript:
	CALL $3275
	LD A, ($D057)
	CP $FF
	JP Z, ResetBrunoScript
	LD A, 1
	LDH ($8C), A
	JP $2920
BrunosRoomEndBattleEnd:
.ASSERT BrunosRoomEndBattleEnd - BrunosRoomBrunoEndBattleScript == 18
