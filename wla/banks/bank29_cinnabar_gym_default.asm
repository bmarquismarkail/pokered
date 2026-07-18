CinnabarGymDefaultScript:
	LD A, ($DA38) ; wOpponentAfterWrongAnswer
	AND A
	RET Z
	LDH ($8C), A ; hSpriteIndex
	CP 4 ; CINNABARGYM_SUPER_NERD3
	JR NZ, CinnabarGymDefaultScript.not_super_nerd3
	LD A, 4 ; PLAYER_DIR_DOWN
	LD ($D528), A ; wPlayerMovingDirection
	LD DE, MovementNpcToLeftAndUp
	JR CinnabarGymDefaultScript.MoveSprite
CinnabarGymDefaultScript.not_super_nerd3:
	LD DE, MovementNpcToLeft
	LD A, 1 ; PLAYER_DIR_RIGHT
	LD ($D528), A
CinnabarGymDefaultScript.MoveSprite:
	CALL $363A ; MoveSprite
	LD A, 1 ; SCRIPT_CINNABARGYM_GET_OPPONENT_TEXT
	LD ($D65E), A ; wCinnabarGymCurScript
	LD ($DA39), A ; wCurMapScript
	RET
MovementNpcToLeftAndUp:
	.DB $80,$40,$FF
MovementNpcToLeft:
	.DB $80,$FF
CinnabarGymDefaultEnd:
.ASSERT CinnabarGymDefaultEnd - CinnabarGymDefaultScript == 46

CinnabarGymGetOpponentTextScript:
	LD A, ($D730) ; wStatusFlags5
	BIT 0, A ; BIT_SCRIPTED_NPC_MOVEMENT
	RET NZ
	XOR A
	LD ($CD6B), A ; wJoyIgnore
	LD A, ($DA38) ; wOpponentAfterWrongAnswer
	LD ($CC55), A ; wTrainerHeaderFlagBit
	LDH ($8C), A ; hTextID
	JP $2920 ; DisplayTextID
CinnabarGymGetOpponentTextEnd:
.ASSERT CinnabarGymGetOpponentTextEnd - CinnabarGymGetOpponentTextScript == 21

CinnabarGymFlagAction:
	LD A, $10 ; FlagActionPredef
	JP $3E6D ; Predef
CinnabarGymFlagActionEnd:
.ASSERT CinnabarGymFlagActionEnd - CinnabarGymFlagAction == 5
