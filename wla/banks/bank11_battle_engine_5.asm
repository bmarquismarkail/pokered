; Native WLA-DX form of engine/battle/display_effectiveness.asm, gfx/trainer_card.asm, engine/items/tmhm.asm, engine/battle/scale_sprites.asm, engine/battle/move_effects/pay_day.asm, engine/slots/game_corner_slots2.asm.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"
DisplayEffectiveness:
	ld a, (wDamageMultipliers)
	and $7F
	cp EFFECTIVE
	ret z
	ld hl, SuperEffectiveText
	jr nc, DisplayEffectiveness.done
	ld hl, NotVeryEffectiveText
DisplayEffectiveness.done:
	jp PrintText

SuperEffectiveText:
	.DB $17
	.DW $5d22
	.DB $22
	.DB $50

NotVeryEffectiveText:
	.DB $17
	.DW $5d38
	.DB $22
	.DB $50
TrainerInfoTextBoxTileGraphics:
	.INCBIN "gfx/trainer_card/trainer_info.2bpp"
TrainerInfoTextBoxTileGraphicsEnd:

BlankLeaderNames:
	.INCBIN "gfx/trainer_card/blank_leader_names.2bpp"

CircleTile:
	.INCBIN "gfx/trainer_card/circle_tile.2bpp"

BadgeNumbersTileGraphics:
	.INCBIN "gfx/trainer_card/badge_numbers.2bpp"
; checks if the mon in [wWhichPokemon] already knows the move in [wMoveNum]
CheckIfMoveIsKnown:
	ld a, (wWhichPokemon)
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, (wMoveNum)
	ld b, a
	ld c, NUM_MOVES
CheckIfMoveIsKnown.loop:
	ld a, (HL+)
	cp b
	jr z, CheckIfMoveIsKnown.alreadyKnown ; found a match
	dec c
	jr nz, CheckIfMoveIsKnown.loop
	and a
	ret
CheckIfMoveIsKnown.alreadyKnown:
	ld hl, AlreadyKnowsText
	call PrintText
	scf
	ret

AlreadyKnowsText:
	.DB $17
	.DW $4088
	.DB $2a
	.DB $50
; scales both uncompressed sprite chunks by two in every dimension (creating 2x2 output pixels per input pixel)
; assumes that input sprite chunks are 4x4 tiles, and the rightmost and bottommost 4 pixels will be ignored
; resulting in a 7*7 tile output sprite chunk
ScaleSpriteByTwo:
	ld de, sSpriteBuffer1 + (4*4*8) - 5 ; last byte of input data, last 4 rows already skipped
	ld hl, sSpriteBuffer0 + SPRITEBUFFERSIZE - 1 ; end of destination buffer
	call ScaleLastSpriteColumnByTwo ; last tile column is special case
	call ScaleFirstThreeSpriteColumnsByTwo ; scale first 3 tile columns
	ld de, sSpriteBuffer2 + (4*4*8) - 5 ; last byte of input data, last 4 rows already skipped
	ld hl, sSpriteBuffer1 + SPRITEBUFFERSIZE - 1 ; end of destination buffer
	call ScaleLastSpriteColumnByTwo ; last tile column is special case

ScaleFirstThreeSpriteColumnsByTwo:
	ld b, $3 ; 3 tile columns
ScaleFirstThreeSpriteColumnsByTwo.columnLoop:
	ld c, 4*8 - 4 ; $1c, 4 tiles minus 4 unused rows
ScaleFirstThreeSpriteColumnsByTwo.columnInnerLoop:
	push bc
	ld a, (de)
	ld bc, -(7*8)+1 ; -$37, scale lower nybble and seek to previous output column
	call ScalePixelsByTwo
	ld a, (de)
	dec de
	swap a
	ld bc, 7*8+1-2 ; $37, scale upper nybble and seek back to current output column and to the next 2 rows
	call ScalePixelsByTwo
	pop bc
	dec c
	jr nz, ScaleFirstThreeSpriteColumnsByTwo.columnInnerLoop
	dec de
	dec de
	dec de
	dec de
	ld a, b
	ld bc, -7*8 ; -$38, skip one output column (which has already been written along with the current one)
	add hl, bc
	ld b, a
	dec b
	jr nz, ScaleFirstThreeSpriteColumnsByTwo.columnLoop
	ret

ScaleLastSpriteColumnByTwo:
	ld a, 4*8 - 4 ; $1c, 4 tiles minus 4 unused rows
	ldh (hSpriteInterlaceCounter - $FF00), a
	ld bc, -1
ScaleLastSpriteColumnByTwo.columnInnerLoop:
	ld a, (de)
	dec de
	swap a ; only high nybble contains information
	call ScalePixelsByTwo
	ldh a, (hSpriteInterlaceCounter - $FF00)
	dec a
	ldh (hSpriteInterlaceCounter - $FF00), a
	jr nz, ScaleLastSpriteColumnByTwo.columnInnerLoop
	dec de ; skip last 4 rows of new column
	dec de
	dec de
	dec de
	ret

; scales the given 4 bits in a (4x1 pixels) to 2 output bytes (8x2 pixels)
; hl: destination pointer
; bc: destination pointer offset (added after the two bytes have been written)
ScalePixelsByTwo:
	push hl
	and $f
	ld hl, DuplicateBitsTable
	add l
	ld l, a
	jr nc, ScalePixelsByTwo.noCarry
	inc h
ScalePixelsByTwo.noCarry:
	ld a, (hl)
	pop hl
	ld (HL-), a ; write output byte twice to make it 2 pixels high
	ld (hl), a
	add hl, bc ; add offset
	ret

; repeats each input bit twice, e.g. DuplicateBitsTable[%0101] = %00110011
DuplicateBitsTable:
	.DB 0, 3, 12, 15, 48, 51, 60, 63, 192, 195, 204, 207, 240, 243, 252, 255
PayDayEffect_:
	xor a
	ld hl, wPayDayMoney
	ld (HL+), a
	ldh a, (hWhoseTurn - $FF00)
	and a
	ld a, (wBattleMonLevel)
	jr z, PayDayEffect_.payDayEffect
	ld a, (wEnemyMonLevel)
PayDayEffect_.payDayEffect:
; level * 2
	add a
	ldh (hDividend - $FF00 + 3), a
	xor a
	ldh (hDividend - $FF00), a
	ldh (hDividend - $FF00 + 1), a
	ldh (hDividend - $FF00 + 2), a
; convert to BCD
	ld a, 100
	ldh (hDivisor - $FF00), a
	ld b, $4
	call Divide
	ldh a, (hQuotient - $FF00 + 3)
	ld (HL+), a ; wPayDayMoney + 1
	ldh a, (hRemainder - $FF00)
	ldh (hDividend - $FF00 + 3), a
	ld a, 10
	ldh (hDivisor - $FF00), a
	ld b, $4
	call Divide
	ldh a, (hQuotient - $FF00 + 3)
	swap a
	ld b, a
	ldh a, (hRemainder - $FF00)
	add b
	ld (hl), a ; wPayDayMoney + 2
	ld de, wTotalPayDayMoney + 2
	ld c, $3
	ld a, $0b
	call Predef
	ld hl, CoinsScatteredText
	jp PrintText

CoinsScatteredText:
	.DB $17
	.DW $497e
	.DB $25
	.DB $50
AbleToPlaySlotsCheck:
	ld a, (wSpritePlayerStateData1ImageIndex)
	and $8
	jr z, AbleToPlaySlotsCheck.done ; not able
	ld b, COIN_CASE
	ld a, $1c
	call Predef
	ld a, b
	and a
	ld b, (GameCornerCoinCaseText_id - TextPredefs) / 2 + 1
	jr z, AbleToPlaySlotsCheck.printCoinCaseRequired
	ld hl, wPlayerCoins
	ld a, (HL+)
	or (hl)
	jr nz, AbleToPlaySlotsCheck.done ; able to play
	ld b, (GameCornerNoCoinsText_id - TextPredefs) / 2 + 1
AbleToPlaySlotsCheck.printCoinCaseRequired:
	call EnableAutoTextBoxDrawing
	ld a, b
	call PrintPredefTextID
	xor a
AbleToPlaySlotsCheck.done:
	ld (wCanPlaySlots), a
	ret

GameCornerCoinCaseText:
	.DB $17
	.DW $4b5b
	.DB $22
	.DB $50

GameCornerNoCoinsText:
	.DB $17
	.DW $4b75
	.DB $22
	.DB $50
BattleEngine5End:
