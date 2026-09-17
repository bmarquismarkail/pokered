ConversionEffect_:
	ld hl, wEnemyMonType1
	ld de, wBattleMonType1
	ldh a, [lobyte(hWhoseTurn)]
	and a
	ld a, [wEnemyBattleStatus1]
	jr z, ConversionEffect_.conversionEffect
	push hl
	ld h, d
	ld l, e
	pop de
	ld a, [wPlayerBattleStatus1]
ConversionEffect_.conversionEffect
	bit INVULNERABLE, a ; is mon immune to typical attacks (dig/fly)
	jr nz, PrintButItFailedText
; copy target's types to user
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, PlayCurrentMoveAnimation
	call CallBankF
	ld hl, ConvertedTypeText
	jp PrintText

ConvertedTypeText:
	text_far WLA_GLOBAL_ConvertedTypeText
	text_end

PrintButItFailedText:
	ld hl, PrintButItFailedText_
CallBankF:
	ld b, bank(PrintButItFailedText_)
	jp Bankswitch
