; Native WLA-DX form of Mist and one-hit-KO move effects.
.DEFINE PrintText $3c49
MistEffect_:
	LD HL, wPlayerBattleStatus2
	LDH A, ($f3)
	AND A
	JR Z, MistEffectApply
	LD HL, wEnemyBattleStatus2
MistEffectApply:
	BIT 1, (HL)
	JR NZ, MistEffectAlreadyInUse
	SET 1, (HL)
	LD HL, $7ba8
	LD B, $0f
	CALL Bankswitch
	LD HL, ShroudedInMistText
	JP PrintText
MistEffectAlreadyInUse:
	LD HL, $7b53
	LD B, $0f
	JP Bankswitch
ShroudedInMistText:
	.DB $17
	.DW $4abf
	.DB $25, $50
OneHitKOEffect_:
	LD HL, wDamage
	XOR A
	LD (HL+), A
	LD (HL), A
	DEC A
	LD (wCriticalHitOrOHKO), A
	LD HL, wBattleMonSpeed + 1
	LD DE, wEnemyMonSpeed + 1
	LDH A, ($f3)
	AND A
	JR Z, OneHitKOCompareSpeed
	LD HL, wEnemyMonSpeed + 1
	LD DE, wBattleMonSpeed + 1
OneHitKOCompareSpeed:
	LD A, (DE)
	DEC DE
	LD B, A
	LD A, (HL-)
	SUB B
	LD A, (DE)
	LD B, A
	LD A, (HL)
	SBC B
	JR C, OneHitKOUserIsSlower
	LD HL, wDamage
	LD A, $ff
	LD (HL+), A
	LD (HL), A
	LD A, $02
	LD (wCriticalHitOrOHKO), A
	RET
OneHitKOUserIsSlower:
	LD A, $01
	LD (wMoveMissed), A
	RET
BattleEngine6End:
