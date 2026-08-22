_RemovePokemon:
WLA_GLOBAL_RemovePokemon:
	ld hl, wPartyCount
	ld a, [wRemoveMonFromBox]
	and a
	jr z, WLA_GLOBAL_RemovePokemon__gotCount
	ld hl, wBoxCount
_RemovePokemon.gotCount:
WLA_GLOBAL_RemovePokemon__gotCount:
	ld a, [hl]
	dec a
	ld [hli], a

	ld a, [wWhichPokemon]
	ld c, a
	ld b, 0
	add hl, bc
	ld e, l
	ld d, h
	inc de
_RemovePokemon.shiftMonSpeciesLoop:
WLA_GLOBAL_RemovePokemon__shiftMonSpeciesLoop:
	ld a, [de]
	inc de
	ld [hli], a
	inc a ; reached terminator?
	jr nz, WLA_GLOBAL_RemovePokemon__shiftMonSpeciesLoop ; if not, continue shifting species

	ld hl, wPartyMonOT
	ld d, PARTY_LENGTH - 1 ; max number of pokemon to shift
	ld a, [wRemoveMonFromBox]
	and a
	jr z, WLA_GLOBAL_RemovePokemon__gotOTsPointer
	ld hl, wBoxMonOT
	ld d, MONS_PER_BOX - 1
_RemovePokemon.gotOTsPointer:
WLA_GLOBAL_RemovePokemon__gotOTsPointer:
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld a, [wWhichPokemon]
	cp d ; are we removing the last pokemon?
	jr nz, WLA_GLOBAL_RemovePokemon__notRemovingLastMon ; if not, shift the pokemon below

	; bug: to erase a string, this should be ld [hl], '@'
	; This is not needed, as wBoxSpecies/wPartySpecies determine if a slot is used.
	; Besides, existing mon nick is left untouched
	ld [hl], $ff
	ret

_RemovePokemon.notRemovingLastMon:
WLA_GLOBAL_RemovePokemon__notRemovingLastMon:
	ld d, h
	ld e, l
	ld bc, NAME_LENGTH
	add hl, bc
	ld bc, wPartyMonNicks
	ld a, [wRemoveMonFromBox]
	and a
	jr z, WLA_GLOBAL_RemovePokemon__gotNicksPointer
	ld bc, wBoxMonNicks
_RemovePokemon.gotNicksPointer:
WLA_GLOBAL_RemovePokemon__gotNicksPointer:
	call CopyDataUntil

	ld hl, wPartyMons
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wRemoveMonFromBox]
	and a
	jr z, WLA_GLOBAL_RemovePokemon__gotMonStructs
	ld hl, wBoxMons
	ld bc, BOXMON_STRUCT_LENGTH
_RemovePokemon.gotMonStructs:
WLA_GLOBAL_RemovePokemon__gotMonStructs:
	ld a, [wWhichPokemon]
	call AddNTimes ; get address of the pokemon removed

	ld d, h ; de = start address for CopyDataUntil
	ld e, l
	ld a, [wRemoveMonFromBox]
	and a
	jr z, WLA_GLOBAL_RemovePokemon__copyUntilPartyMonOT
; copy until wBoxMonOT
	ld bc, BOXMON_STRUCT_LENGTH
	add hl, bc ; get address of next slot
	ld bc, wBoxMonOT
	jr WLA_GLOBAL_RemovePokemon__shiftOTs
_RemovePokemon.copyUntilPartyMonOT:
WLA_GLOBAL_RemovePokemon__copyUntilPartyMonOT:
	ld bc, PARTYMON_STRUCT_LENGTH
	add hl, bc ; get address of next slot
	ld bc, wPartyMonOT
_RemovePokemon.shiftOTs:
WLA_GLOBAL_RemovePokemon__shiftOTs:
	call CopyDataUntil ; shift all pokemon data up one slot

	ld hl, wPartyMonNicks
	ld a, [wRemoveMonFromBox]
	and a
	jr z, WLA_GLOBAL_RemovePokemon__gotNicksPointer2
	ld hl, wBoxMonNicks
_RemovePokemon.gotNicksPointer2:
WLA_GLOBAL_RemovePokemon__gotNicksPointer2:
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes

	ld d, h
	ld e, l
	ld bc, NAME_LENGTH
	add hl, bc
	ld bc, wPartyMonNicksEnd
	ld a, [wRemoveMonFromBox]
	and a
	jr z, WLA_GLOBAL_RemovePokemon__shiftMonNicks
	ld bc, wBoxMonNicksEnd
_RemovePokemon.shiftMonNicks:
WLA_GLOBAL_RemovePokemon__shiftMonNicks:
	jp CopyDataUntil ; shift all pokemon nicknames up one slot
