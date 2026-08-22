HealEffect_:
	ldh a, [lobyte(hWhoseTurn)]
	and a
	ld de, wBattleMonHP
	ld hl, wBattleMonMaxHP
	ld a, [wPlayerMoveNum]
	jr z, HealEffect_.healEffect
	ld de, wEnemyMonHP
	ld hl, wEnemyMonMaxHP
	ld a, [wEnemyMoveNum]
HealEffect_.healEffect
	ld b, a
	ld a, [de]
	cp [hl] ; most significant bytes comparison is ignored
	        ; causes the move to miss if max HP is 255 or 511 points higher than the current HP
	inc de
	inc hl
	ld a, [de]
	sbc [hl]
	jp z, HealEffect_.failed ; no effect if user's HP is already at its maximum
	ld a, b
	cp REST
	jr nz, HealEffect_.healHP
	push hl
	push de
	push af
	ld c, 50
	call DelayFrames
	ld hl, wBattleMonStatus
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, HealEffect_.restEffect
	ld hl, wEnemyMonStatus
HealEffect_.restEffect
	ld a, [hl]
	and a
	ld [hl], 2 ; clear status and set number of turns asleep to 2
	ld hl, StartedSleepingEffect ; if mon didn't have an status
	jr z, HealEffect_.printRestText
	ld hl, FellAsleepBecameHealthyText ; if mon had an status
HealEffect_.printRestText
	call PrintText
	pop af
	pop de
	pop hl
HealEffect_.healHP
	ld a, [hld]
	ld [wHPBarMaxHP], a
	ld c, a
	ld a, [hl]
	ld [wHPBarMaxHP+1], a
	ld b, a
	jr z, HealEffect_.gotHPAmountToHeal
; Recover and Softboiled only heal for half the mon's max HP
	srl b
	rr c
HealEffect_.gotHPAmountToHeal
; update HP
	ld a, [de]
	ld [wHPBarOldHP], a
	add c
	ld [de], a
	ld [wHPBarNewHP], a
	dec de
	ld a, [de]
	ld [wHPBarOldHP+1], a
	adc b
	ld [de], a
	ld [wHPBarNewHP+1], a
	inc hl
	inc de
	ld a, [de]
	dec de
	sub [hl]
	dec hl
	ld a, [de]
	sbc [hl]
	jr c, HealEffect_.playAnim
; copy max HP to current HP if an overflow occurred
	ld a, [hli]
	ld [de], a
	ld [wHPBarNewHP+1], a
	inc de
	ld a, [hl]
	ld [de], a
	ld [wHPBarNewHP], a
HealEffect_.playAnim
	ld hl, PlayCurrentMoveAnimation
	call EffectCallBattleCore
	ldh a, [lobyte(hWhoseTurn)]
	and a
	hlcoord 10, 9
	ld a, $1
	jr z, HealEffect_.updateHPBar
	hlcoord 2, 2
	xor a
HealEffect_.updateHPBar
	ld [wHPBarType], a
	predef UpdateHPBar2
	ld hl, DrawHUDsAndHPBars
	call EffectCallBattleCore
	ld hl, RegainedHealthText
	jp PrintText
HealEffect_.failed
	ld c, 50
	call DelayFrames
	ld hl, PrintButItFailedText_
	jp EffectCallBattleCore

StartedSleepingEffect:
	text_far WLA_GLOBAL_StartedSleepingEffect
	text_end

FellAsleepBecameHealthyText:
	text_far WLA_GLOBAL_FellAsleepBecameHealthyText
	text_end

RegainedHealthText:
	text_far WLA_GLOBAL_RegainedHealthText
	text_end
