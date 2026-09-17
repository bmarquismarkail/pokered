HealParty:
; Restore HP and PP.

	ld hl, wPartySpecies
	ld de, wPartyMon1HP
HealParty.healmon
	ld a, [hli]
	cp $ff
	jr z, HealParty.done

	push hl
	push de

	ld hl, MON_STATUS - MON_HP
	add hl, de
	xor a
	ld [hl], a

	push de
	ld b, NUM_MOVES ; A Pokémon has 4 moves
HealParty.pp
	ld hl, MON_MOVES - MON_HP
	add hl, de

	ld a, [hl]
	and a
	jr z, HealParty.nextmove

	dec a
	ld hl, MON_PP - MON_HP
	add hl, de

	push hl
	push de
	push bc

	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wMoveData
	ld a, bank(Moves)
	call FarCopyData
	ld a, [wMoveData + MOVE_PP]

	pop bc
	pop de
	pop hl

	inc de
	push bc
	ld b, a
	ld a, [hl]
	and PP_UP_MASK
	add b
	ld [hl], a
	pop bc

HealParty.nextmove
	dec b
	jr nz, HealParty.pp
	pop de

	ld hl, MON_MAXHP - MON_HP
	add hl, de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	pop de
	pop hl

	push hl
	ld bc, PARTYMON_STRUCT_LENGTH
	ld h, d
	ld l, e
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	jr HealParty.healmon

HealParty.done
	xor a
	ld [wWhichPokemon], a
	ld [wUsingPPUp], a

	ld a, [wPartyCount]
	ld b, a
HealParty.ppup
	push bc
	call RestoreBonusPP
	pop bc
	ld hl, wWhichPokemon
	inc [hl]
	dec b
	jr nz, HealParty.ppup
	ret
