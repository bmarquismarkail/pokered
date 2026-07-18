AgathasRoomDefaultScript:
	LD HL, AgathaEntranceCoords
	CALL $34BF ; ArePlayerCoordsInArray
	JP NC, $3219 ; CheckFightingMapTrainers
	XOR A
	LDH ($B3), A ; hJoyPressed
	LDH ($B4), A ; hJoyHeld
	LD ($CCD3), A ; wSimulatedJoypadStatesEnd
	LD ($CD38), A ; wSimulatedJoypadStatesIndex
	LD A, ($CD3D) ; wCoordIndex
	CP 3
	JR C, AgathasRoomDefaultScript.stopPlayer
	LD HL, $D865
	BIT 6, (HL) ; EVENT_AUTOWALKED_INTO_AGATHAS_ROOM
	SET 6, (HL)
	JR Z, AgathaScriptWalkIntoRoom
AgathasRoomDefaultScript.stopPlayer:
	LD A, 2 ; TEXT_AGATHASROOM_AGATHA_DONT_RUN_AWAY
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	LD A, $40 ; PAD_UP
	LD ($CCD3), A
	LD A, 1
	LD ($CD38), A
	CALL $3486 ; StartSimulatingJoypadStates
	LD A, 3 ; SCRIPT_AGATHASROOM_PLAYER_IS_MOVING
	LD ($D64F), A
	LD ($DA39), A ; wCurMapScript
	RET
AgathasRoomDefaultEnd:
.ASSERT AgathasRoomDefaultEnd - AgathasRoomDefaultScript == 65

AgathaEntranceCoords:
	.DB $0A,$04,$0A,$05,$0B,$04,$0B,$05,$FF
AgathaEntranceCoordsEnd:
.ASSERT AgathaEntranceCoordsEnd - AgathaEntranceCoords == 9

AgathasRoomPlayerIsMovingScript:
	LD A, ($CD38) ; wSimulatedJoypadStatesIndex
	AND A
	RET NZ
	CALL $3DD7 ; Delay3
	XOR A
	LD ($CD6B), A ; wJoyIgnore
	LD ($D64F), A
	LD ($DA39), A ; wCurMapScript
	RET
AgathasRoomPlayerMovingEnd:
.ASSERT AgathasRoomPlayerMovingEnd - AgathasRoomPlayerIsMovingScript == 19

AgathasRoomAgathaEndBattleScript:
	CALL $3275 ; EndTrainerBattle
	LD A, ($D057) ; wIsInBattle
	CP $FF
	JP Z, ResetAgathaScript
	LD A, 1 ; TEXT_AGATHASROOM_AGATHA
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	LD A, 1 ; SCRIPT_CHAMPIONSROOM_PLAYER_ENTERS
	LD ($D64C), A ; wChampionsRoomCurScript
	RET
AgathasRoomEndBattleEnd:
.ASSERT AgathasRoomEndBattleEnd - AgathasRoomAgathaEndBattleScript == 24
