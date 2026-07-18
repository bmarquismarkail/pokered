ChampionsRoomOakCongratulatesPlayerScript:
	LD A, ($D730)
	BIT 0, A
	RET NZ
	LD A, 2
	LD ($D528), A
	LD A, 1
	LDH ($8C), A
	LD A, 8
	LDH ($8D), A
	CALL $34A6
	LD A, 2
	LDH ($8C), A
	XOR A
	LDH ($8D), A
	CALL $34A6
	LD A, 3
	LDH ($8C), A
	CALL ChampionsRoom_DisplayTextID_AllowABSelectStart
	LD A, 6
	LD ($D64C), A
	RET
ChampionsRoomOakCongratulatesEnd:
.ASSERT ChampionsRoomOakCongratulatesEnd - ChampionsRoomOakCongratulatesPlayerScript == 45

ChampionsRoomOakDisappointedWithRivalScript:
	LD A, 2
	LDH ($8C), A
	LD A, $0C
	LDH ($8D), A
	CALL $34A6
	LD A, 4
	LDH ($8C), A
	CALL ChampionsRoom_DisplayTextID_AllowABSelectStart
	LD A, 7
	LD ($D64C), A
	RET
ChampionsRoomOakDisappointedEnd:
.ASSERT ChampionsRoomOakDisappointedEnd - ChampionsRoomOakDisappointedWithRivalScript == 24

ChampionsRoomOakComeWithMeScript:
	LD A, 2
	LDH ($8C), A
	XOR A
	LDH ($8D), A
	CALL $34A6
	LD A, 5
	LDH ($8C), A
	CALL ChampionsRoom_DisplayTextID_AllowABSelectStart
	LD DE, OakExitChampionsRoomMovement
	LD A, 2
	LDH ($8C), A
	CALL $363A ; MoveSprite
	LD A, 8
	LD ($D64C), A
	RET
ChampionsRoomOakComeWithMeEnd:
.ASSERT ChampionsRoomOakComeWithMeEnd - ChampionsRoomOakComeWithMeScript == 33

OakExitChampionsRoomMovement:
	.DB $40,$40,$FF
OakExitChampionsRoomMovementEnd:
.ASSERT OakExitChampionsRoomMovementEnd - OakExitChampionsRoomMovement == 3

ChampionsRoomOakExitsScript:
	LD A, ($D730)
	BIT 0, A
	RET NZ
	LD A, $D6
	LD ($CC4D), A
	LD A, $11 ; HideObject predef
	CALL $3E6D
	LD A, 9
	LD ($D64C), A
	RET
ChampionsRoomOakExitsEnd:
.ASSERT ChampionsRoomOakExitsEnd - ChampionsRoomOakExitsScript == 22

ChampionsRoomPlayerFollowsOakScript:
	LD A, $FF
	LD ($CD6B), A
	LD HL, $CCD3
	LD DE, WalkToHallOfFame_RLEMovement
	CALL $350C
	DEC A
	LD ($CD38), A
	CALL $3486
	LD A, 10
	LD ($D64C), A
	RET
ChampionsRoomPlayerFollowsOakEnd:
.ASSERT ChampionsRoomPlayerFollowsOakEnd - ChampionsRoomPlayerFollowsOakScript == 27

WalkToHallOfFame_RLEMovement:
	.DB $40,$04,$20,$01,$FF
WalkToHallOfFameRLEEnd:
.ASSERT WalkToHallOfFameRLEEnd - WalkToHallOfFame_RLEMovement == 5

ChampionsRoomCleanupScript:
	LD A, ($CD38)
	AND A
	RET NZ
	XOR A
	LD ($CD6B), A
	LD A, 0
	LD ($D64C), A
	RET
ChampionsRoomCleanupEnd:
.ASSERT ChampionsRoomCleanupEnd - ChampionsRoomCleanupScript == 15

ChampionsRoom_DisplayTextID_AllowABSelectStart:
	LD A, $F0
	LD ($CD6B), A
	CALL $2920 ; DisplayTextID
	LD A, $FF
	LD ($CD6B), A
	RET
ChampionsRoomDisplayTextEnd:
.ASSERT ChampionsRoomDisplayTextEnd - ChampionsRoom_DisplayTextID_AllowABSelectStart == 14
