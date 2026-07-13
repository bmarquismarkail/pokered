; Native WLA-DX form of engine/battle/move_effects/leech_seed.asm.
LeechSeedEffect_:
	LD HL, $656b ; MoveHitTest
	LD B, $0f
	CALL Bankswitch
	LD A, (wMoveMissed)
	AND A
	JR NZ, LeechSeedEffectMoveMissed
	LD HL, wEnemyBattleStatus2
	LD DE, wEnemyMonType1
	LDH A, ($f3) ; hWhoseTurn
	AND A
	JR Z, LeechSeedEffectApply
	LD HL, wPlayerBattleStatus2
	LD DE, wBattleMonType1
LeechSeedEffectApply:
	LD A, (DE)
	CP $16 ; GRASS
	JR Z, LeechSeedEffectMoveMissed
	INC DE
	LD A, (DE)
	CP $16 ; GRASS
	JR Z, LeechSeedEffectMoveMissed
	BIT 7, (HL) ; SEEDED
	JR NZ, LeechSeedEffectMoveMissed
	SET 7, (HL)
	LD HL, $7ba8 ; PlayCurrentMoveAnimation
	LD B, $0f
	CALL Bankswitch
	LD HL, WasSeededText
	JP PrintText
LeechSeedEffectMoveMissed:
	LD C, 50
	CALL DelayFrames
	LD HL, EvadedAttackText
	JP PrintText

WasSeededText:
	.DB $17
	.DW $49af ; _WasSeededText
	.DB $25, $50
EvadedAttackText:
	.DB $17
	.DW $49be ; _EvadedAttackText
	.DB $25, $50
LeechSeedSectionEnd:
