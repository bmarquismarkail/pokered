VermilionGym_ScriptPointers:
.DW $3219, $324C, $3275, $4A9D
VermilionGymScriptPointersEnd:
.ASSERT VermilionGymScriptPointersEnd - VermilionGym_ScriptPointers == 8

VermilionGymLTSurgeAfterBattleScript:
	LD A, ($D057)
	CP $FF
	JP Z, VermilionGymResetScripts
	LD A, $F0
	LD ($CD6B), A
VermilionGymLTSurgeReceiveTM24Script:
	LD A, $06
	LDH ($8C), A
	CALL $2920
	LD HL, $D773
	SET 7, (HL)
	LD BC, $E001
	CALL $3E2E
	JR NC, VermilionGymLTSurgeReceiveTM24Script.bag_full
	LD A, $07
	LDH ($8C), A
	CALL $2920
	LD HL, $D773
	SET 6, (HL)
	JR VermilionGymLTSurgeReceiveTM24Script.gym_victory
VermilionGymLTSurgeReceiveTM24Script.bag_full:
	LD A, $08
	LDH ($8C), A
	CALL $2920
VermilionGymLTSurgeReceiveTM24Script.gym_victory:
	LD HL, $D356
	SET 2, (HL)
	LD HL, $D72A
	SET 2, (HL)
	LD A, ($D773)
	OR $1C
	LD ($D773), A
	JP VermilionGymResetScripts
VermilionGymBattleControlEnd:
.ASSERT VermilionGymBattleControlEnd - VermilionGymLTSurgeAfterBattleScript == 75
