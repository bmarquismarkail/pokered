_GivePokemon:
WLA_GLOBAL_GivePokemon:
; returns success in carry
; and whether the mon was added to the party in [wAddedToParty]
	call EnableAutoTextBoxDrawing
	xor a
	ld [wAddedToParty], a
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	jr c, WLA_GLOBAL_GivePokemon__addToParty
	ld a, [wBoxCount]
	cp MONS_PER_BOX
	jr nc, WLA_GLOBAL_GivePokemon__boxFull
; add to box
	xor a
	ld [wEnemyBattleStatus3], a
	ld a, [wCurPartySpecies]
	ld [wEnemyMonSpecies2], a
	callfar LoadEnemyMonData
	call SetPokedexOwnedFlag
	callfar SendNewMonToBox
	ld hl, wStringBuffer
	ld a, [wCurrentBoxNum]
	and BOX_NUM_MASK
	cp 9
	jr c, WLA_GLOBAL_GivePokemon__singleDigitBoxNum
	sub 9
	ld [hl], $f7
	inc hl
	add $f6
	jr WLA_GLOBAL_GivePokemon__next
_GivePokemon.singleDigitBoxNum:
WLA_GLOBAL_GivePokemon__singleDigitBoxNum:
	add $f7
_GivePokemon.next:
WLA_GLOBAL_GivePokemon__next:
	ld [hli], a
	ld [hl], $50
	ld hl, SentToBoxText
	call PrintText
	scf
	ret
_GivePokemon.boxFull:
WLA_GLOBAL_GivePokemon__boxFull:
	ld hl, BoxIsFullText
	call PrintText
	and a
	ret
_GivePokemon.addToParty:
WLA_GLOBAL_GivePokemon__addToParty:
	call SetPokedexOwnedFlag
	call AddPartyMon
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld [wAddedToParty], a
	scf
	ret

SetPokedexOwnedFlag:
	ld a, [wCurPartySpecies]
	push af
	ld [wPokedexNum], a
	predef IndexToPokedex
	ld a, [wPokedexNum]
	dec a
	ld c, a
	ld hl, wPokedexOwned
	ld b, FLAG_SET
	predef FlagActionPredef
	pop af
	ld [wNamedObjectIndex], a
	call GetMonName
	ld hl, GotMonText
	jp PrintText

GotMonText:
	text_far WLA_GLOBAL_GotMonText
	sound_get_item_1
	text_end

SentToBoxText:
	text_far WLA_GLOBAL_SentToBoxText
	text_end

BoxIsFullText:
	text_far WLA_GLOBAL_BoxIsFullText
	text_end
