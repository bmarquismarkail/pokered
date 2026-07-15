FightingDojoDefaultScript:
	LD A, ($D7B1)
	BIT 0, A ; EVENT_DEFEATED_FIGHTING_DOJO
	RET NZ
	CALL $3219 ; CheckFightingMapTrainers
	LD A, ($CC55) ; wTrainerHeaderFlagBit
	AND A
	RET NZ
	LD A, ($D7B1)
	BIT 1, A ; EVENT_BEAT_KARATE_MASTER
	RET NZ
	XOR A
	LDH ($B4), A
	LD ($CF0D), A ; wSavedCoordIndex
	LD A, ($D361) ; wYCoord
	CP 3
	RET NZ
	LD A, ($D362) ; wXCoord
	CP 4
	RET NZ
	LD A, 1
	LD ($CF0D), A
	LD A, 1 ; PLAYER_DIR_RIGHT
	LD ($D528), A
	LD A, 1 ; FIGHTINGDOJO_KARATE_MASTER
	LDH ($8C), A
	LD A, 8 ; SPRITE_FACING_LEFT
	LDH ($8D), A
	CALL $34A6 ; SetSpriteFacingDirectionAndDelay
	LD A, 1
	LDH ($8C), A ; hTextID
	CALL $2920
	RET
FightingDojoDefaultScriptEnd:
.ASSERT FightingDojoDefaultScriptEnd - FightingDojoDefaultScript == 67
