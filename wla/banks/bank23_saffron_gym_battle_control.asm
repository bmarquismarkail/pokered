SaffronGymSabrinaPostBattle:
	LD A, ($D057)
	CP $FF
	JP Z, SaffronGymResetScripts
	LD A, $F0
	LD ($CD6B), A
SaffronGymSabrinaReceiveTM46Script:
	LD A, $0A
	LDH ($8C), A
	CALL $2920
	LD HL, $D7B3
	SET 1, (HL) ; EVENT_BEAT_SABRINA
	LD BC, $F601 ; one TM_PSYWAVE
	CALL $3E2E
	JR NC, SaffronGymSabrinaReceiveTM46Script.BagFull
	LD A, $0B
	LDH ($8C), A
	CALL $2920
	LD HL, $D7B3
	SET 0, (HL) ; EVENT_GOT_TM46
	JR SaffronGymSabrinaReceiveTM46Script.gymVictory
SaffronGymSabrinaReceiveTM46Script.BagFull:
	LD A, $0C
	LDH ($8C), A
	CALL $2920
SaffronGymSabrinaReceiveTM46Script.gymVictory:
	LD HL, $D356
	SET 5, (HL)
	LD HL, $D72A
	SET 5, (HL)
	LD A, ($D7B3)
	OR $FC
	LD ($D7B3), A
	LD HL, $D7B4
	SET 0, (HL)
	JP SaffronGymResetScripts
SaffronGymBattleControlEnd:
.ASSERT SaffronGymBattleControlEnd - SaffronGymSabrinaPostBattle == 80
