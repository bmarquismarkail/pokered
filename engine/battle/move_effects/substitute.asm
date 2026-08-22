SubstituteEffect_:
	ld c, 50
	call DelayFrames
	ld hl, wBattleMonMaxHP
	ld de, wPlayerSubstituteHP
	ld bc, wPlayerBattleStatus2
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, SubstituteEffect_.notEnemy
	ld hl, wEnemyMonMaxHP
	ld de, wEnemySubstituteHP
	ld bc, wEnemyBattleStatus2
SubstituteEffect_.notEnemy
	ld a, [bc]
	bit HAS_SUBSTITUTE_UP, a ; user already has substitute?
	jr nz, SubstituteEffect_.alreadyHasSubstitute
; quarter health to remove from user
; assumes max HP is 1023 or lower
	push bc
	ld a, [hli]
	ld b, [hl]
	srl a
	rr b
	srl a
	rr b ; max hp / 4
	push de
	ld de, wBattleMonHP - wBattleMonMaxHP
	add hl, de ; point hl to current HP low byte
	pop de
	ld a, b
	ld [de], a ; save copy of HP to subtract in wPlayerSubstituteHP/wEnemySubstituteHP
	ld a, [hld]
; subtract [max hp / 4] to current HP
	sub b
	ld d, a
	ld a, [hl]
	sbc 0
	pop bc
	jr c, SubstituteEffect_.notEnoughHP ; underflow means user would be left with negative health
                       ; bug: since it only branches on carry, it will possibly leave user with 0 HP
; user has 0 or more HP
	ld [hli], a ; save resulting HP after subtraction into current HP
	ld [hl], d
	ld h, b
	ld l, c
	set HAS_SUBSTITUTE_UP, [hl]
	ld a, [wOptions]
	bit BIT_BATTLE_ANIMATION, a
	ld hl, PlayCurrentMoveAnimation
	ld b, bank(PlayCurrentMoveAnimation)
	jr z, SubstituteEffect_.animationEnabled
	ld hl, AnimationSubstitute
	ld b, bank(AnimationSubstitute)
SubstituteEffect_.animationEnabled
	call Bankswitch ; jump to routine depending on animation setting
	ld hl, SubstituteText
	call PrintText
	jpfar DrawHUDsAndHPBars
SubstituteEffect_.alreadyHasSubstitute
	ld hl, HasSubstituteText
	jr SubstituteEffect_.printText
SubstituteEffect_.notEnoughHP
	ld hl, TooWeakSubstituteText
SubstituteEffect_.printText
	jp PrintText

SubstituteText:
	text_far WLA_GLOBAL_SubstituteText
	text_end

HasSubstituteText:
	text_far WLA_GLOBAL_HasSubstituteText
	text_end

TooWeakSubstituteText:
	text_far WLA_GLOBAL_TooWeakSubstituteText
	text_end
