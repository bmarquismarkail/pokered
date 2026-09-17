NamePointers:
; entries correspond to *_NAME constants
	.DW MonsterNames
	.DW MoveNames
	.DW UnusedBadgeNames
	.DW ItemNames
	.DW wPartyMonOT ; player's OT names list
	.DW wEnemyMonOT ; enemy's OT names list
	.DW TrainerNames

GetName:
; arguments:
; [wNameListIndex] = which name
; [wNameListType] = which list
; [wPredefBank] = bank of list
;
; returns pointer to name in de
	ld a, [wNameListIndex]
	ld [wNamedObjectIndex], a

	; TM names are separate from item names.
	; BUG: This applies to all names instead of just items.
	.ASSERT NUM_POKEMON_INDEXES < HM01
	.ASSERT NUM_ATTACKS < HM01
	.ASSERT NUM_TRAINERS < HM01
	cp HM01
	jp nc, GetMachineName

	ldh a, [lobyte(hLoadedROMBank)]
	push af
	push hl
	push bc
	push de
	ld a, [wNameListType]
	dec a
	jr nz, GetName.otherEntries
	; 1 = MONSTER_NAME
	call GetMonName
	ld hl, NAME_LENGTH
	add hl, de
	ld e, l
	ld d, h
	jr GetName.gotPtr
GetName.otherEntries
	; 2-7 = other names
	ld a, [wPredefBank]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ld a, [wNameListType]
	dec a
	add a
	ld d, 0
	ld e, a
	jr nc, GetName.skip
	inc d
GetName.skip
	ld hl, NamePointers
	add hl, de
	ld a, [hli]
	ldh [lobyte(hSwapTemp + 1)], a
	ld a, [hl]
	ldh [lobyte(hSwapTemp)], a
	ldh a, [lobyte(hSwapTemp)]
	ld h, a
	ldh a, [lobyte(hSwapTemp + 1)]
	ld l, a
	ld a, [wNameListIndex]
	ld b, a ; wanted entry
	ld c, 0 ; entry counter
GetName.nextName
	ld d, h
	ld e, l
GetName.nextChar
	ld a, [hli]
	cp $50
	jr nz, GetName.nextChar
	inc c
	ld a, b
	cp c
	jr nz, GetName.nextName
	ld h, d
	ld l, e
	ld de, wNameBuffer
	ld bc, NAME_BUFFER_LENGTH
	call CopyData
GetName.gotPtr
	ld a, e
	ld [wUnusedNamePointer], a
	ld a, d
	ld [wUnusedNamePointer + 1], a
	pop de
	pop bc
	pop hl
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret
