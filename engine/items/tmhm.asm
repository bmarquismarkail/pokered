; checks if the mon in [wWhichPokemon] already knows the move in [wMoveNum]
CheckIfMoveIsKnown:
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [wMoveNum]
	ld b, a
	ld c, NUM_MOVES
CheckIfMoveIsKnown.loop
	ld a, [hli]
	cp b
	jr z, CheckIfMoveIsKnown.alreadyKnown ; found a match
	dec c
	jr nz, CheckIfMoveIsKnown.loop
	and a
	ret
CheckIfMoveIsKnown.alreadyKnown
	ld hl, AlreadyKnowsText
	call PrintText
	scf
	ret

AlreadyKnowsText:
	text_far WLA_GLOBAL_AlreadyKnowsText
	text_end
