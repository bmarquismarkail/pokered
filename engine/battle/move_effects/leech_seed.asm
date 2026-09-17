LeechSeedEffect_:
	callfar MoveHitTest
	ld a, [wMoveMissed]
	and a
	jr nz, LeechSeedEffect_.moveMissed
	ld hl, wEnemyBattleStatus2
	ld de, wEnemyMonType1
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, LeechSeedEffect_.leechSeedEffect
	ld hl, wPlayerBattleStatus2
	ld de, wBattleMonType1
LeechSeedEffect_.leechSeedEffect
; miss if the target is grass-type or already seeded
	ld a, [de]
	cp GRASS
	jr z, LeechSeedEffect_.moveMissed
	inc de
	ld a, [de]
	cp GRASS
	jr z, LeechSeedEffect_.moveMissed
	bit SEEDED, [hl]
	jr nz, LeechSeedEffect_.moveMissed
	set SEEDED, [hl]
	callfar PlayCurrentMoveAnimation
	ld hl, WasSeededText
	jp PrintText
LeechSeedEffect_.moveMissed
	ld c, 50
	call DelayFrames
	ld hl, EvadedAttackText
	jp PrintText

WasSeededText:
	text_far WLA_GLOBAL_WasSeededText
	text_end

EvadedAttackText:
	text_far WLA_GLOBAL_EvadedAttackText
	text_end
