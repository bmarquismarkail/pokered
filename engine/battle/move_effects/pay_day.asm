PayDayEffect_:
	xor a
	ld hl, wPayDayMoney
	ld [hli], a
	ldh a, [lobyte(hWhoseTurn)]
	and a
	ld a, [wBattleMonLevel]
	jr z, PayDayEffect_.payDayEffect
	ld a, [wEnemyMonLevel]
PayDayEffect_.payDayEffect
; level * 2
	add a
	ldh [lobyte(hDividend + 3)], a
	xor a
	ldh [lobyte(hDividend)], a
	ldh [lobyte(hDividend + 1)], a
	ldh [lobyte(hDividend + 2)], a
; convert to BCD
	ld a, 100
	ldh [lobyte(hDivisor)], a
	ld b, $4
	call Divide
	ldh a, [lobyte(hQuotient + 3)]
	ld [hli], a ; wPayDayMoney + 1
	ldh a, [lobyte(hRemainder)]
	ldh [lobyte(hDividend + 3)], a
	ld a, 10
	ldh [lobyte(hDivisor)], a
	ld b, $4
	call Divide
	ldh a, [lobyte(hQuotient + 3)]
	swap a
	ld b, a
	ldh a, [lobyte(hRemainder)]
	add b
	ld [hl], a ; wPayDayMoney + 2
	ld de, wTotalPayDayMoney + 2
	ld c, $3
	predef AddBCDPredef
	ld hl, CoinsScatteredText
	jp PrintText

CoinsScatteredText:
	text_far WLA_GLOBAL_CoinsScatteredText
	text_end
