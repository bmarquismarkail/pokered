; Oak's Lab exit guard and forced walk-back states.
OaksLabPlayerDontGoAwayScript:
	LD A, ($D361) ; wYCoord
	CP 6
	RET NZ
	LD A, 5 ; OAKSLAB_OAK1
	LDH ($8C), A ; hSpriteIndex
	XOR A ; SPRITE_FACING_DOWN
	LDH ($8D), A ; hSpriteFacingDirection
	CALL $34A6 ; SetSpriteFacingDirectionAndDelay
	LD A, 1 ; OAKSLAB_RIVAL
	LDH ($8C), A
	XOR A
	LDH ($8D), A
	CALL $34A6
	CALL $2429 ; UpdateSprites
	LD A, $0C ; TEXT_OAKSLAB_OAK_DONT_GO_AWAY_YET
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	LD A, 1
	LD ($CD38), A ; wSimulatedJoypadStatesIndex
	LD A, $40 ; PAD_UP
	LD ($CCD3), A ; wSimulatedJoypadStatesEnd
	CALL $3486 ; StartSimulatingJoypadStates
	LD A, 8 ; PLAYER_DIR_UP
	LD ($D528), A ; wPlayerMovingDirection
	LD A, 7 ; SCRIPT_OAKSLAB_PLAYER_FORCED_TO_WALK_BACK_SCRIPT
	LD ($D5F0), A ; wOaksLabCurScript
	RET
OaksLabPlayerDontGoAwayEnd:
.ASSERT OaksLabPlayerDontGoAwayEnd - OaksLabPlayerDontGoAwayScript == 60

OaksLabPlayerForcedToWalkBackScript:
	LD A, ($CD38) ; wSimulatedJoypadStatesIndex
	AND A
	RET NZ
	CALL $3DD7 ; Delay3
	LD A, 6 ; SCRIPT_OAKSLAB_PLAYER_DONT_GO_AWAY_SCRIPT
	LD ($D5F0), A
	RET
OaksLabPlayerForcedWalkBackEnd:
.ASSERT OaksLabPlayerForcedWalkBackEnd - OaksLabPlayerForcedToWalkBackScript == 14
