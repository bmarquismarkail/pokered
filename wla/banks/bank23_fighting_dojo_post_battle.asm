FightingDojoKarateMasterPostBattleScript:
	LD A, ($D057)
	CP $FF
	JP Z, FightingDojoResetScripts
	LD A, ($CF0D)
	AND A
	JR Z, FightingDojoKarateMasterPostBattleScript.already_facing
	LD A, 1
	LD ($D528), A
	LD A, 1
	LDH ($8C), A
	LD A, 8
	LDH ($8D), A
	CALL $34A6
FightingDojoKarateMasterPostBattleScript.already_facing:
	LD A, $F0
	LD ($CD6B), A
	LD A, ($D7B1)
	OR $3E
	LD ($D7B1), A
	LD A, 8
	LDH ($8C), A
	CALL $2920
	XOR A
	LD ($CD6B), A
	LD ($D642), A
	LD ($DA39), A
	RET
FightingDojoPostBattleEnd:
.ASSERT FightingDojoPostBattleEnd - FightingDojoKarateMasterPostBattleScript == 61
