GetMonName:
	push hl
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ld a, bank(MonsterNames)
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ld a, [wNamedObjectIndex]
	dec a
	ld hl, MonsterNames
	ld c, NAME_LENGTH - 1
	ld b, 0
	call AddNTimes
	ld de, wNameBuffer
	push de
	ld bc, NAME_LENGTH - 1
	call CopyData
	ld hl, wNameBuffer + NAME_LENGTH - 1
	ld [hl], $50
	pop de
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	pop hl
	ret

GetItemName:
; given an item ID at [wNamedObjectIndex], store the name of the item in wNameBuffer
	push hl
	push bc
	ld a, [wNamedObjectIndex]
	cp HM01 ; is this a TM/HM?
	jr nc, GetItemName.Machine

	ld [wNameListIndex], a
	ld a, ITEM_NAME
	ld [wNameListType], a
	ld a, bank(ItemNames)
	ld [wPredefBank], a
	call GetName
	jr GetItemName.Finish

GetItemName.Machine
	call GetMachineName
GetItemName.Finish
	ld de, wNameBuffer
	pop bc
	pop hl
	ret

GetMachineName:
; copies the name of the TM/HM in [wNamedObjectIndex] to wNameBuffer
	push hl
	push de
	push bc
	ld a, [wNamedObjectIndex]
	push af
	cp TM01 ; is this a TM? [not HM]
	jr nc, GetMachineName.WriteTM
; if HM, then write "HM" and add NUM_HMS to the item ID, so we can reuse the
; TM printing code
	add NUM_HMS
	ld [wNamedObjectIndex], a
	ld hl, HiddenPrefix ; points to "HM"
	ld bc, 2
	jr GetMachineName.WriteMachinePrefix
GetMachineName.WriteTM
	ld hl, TechnicalPrefix ; points to "TM"
	ld bc, 2
GetMachineName.WriteMachinePrefix
	ld de, wNameBuffer
	call CopyData

; now get the machine number and convert it to text
	ld a, [wNamedObjectIndex]
	sub TM01 - 1
	ld b, $f6
GetMachineName.FirstDigit
	sub 10
	jr c, GetMachineName.SecondDigit
	inc b
	jr GetMachineName.FirstDigit
GetMachineName.SecondDigit
	add 10
	push af
	ld a, b
	ld [de], a
	inc de
	pop af
	ld b, $f6
	add b
	ld [de], a
	inc de
	ld a, $50
	ld [de], a
	pop af
	ld [wNamedObjectIndex], a
	pop bc
	pop de
	pop hl
	ret

TechnicalPrefix:
		.STRINGMAP pokemon, "TM"
HiddenPrefix:
		.STRINGMAP pokemon, "HM"

; sets carry if item is HM, clears carry if item is not HM
; Input: a = item ID
IsItemHM:
	cp HM01
	jr c, IsItemHM.notHM
	cp TM01
	ret
IsItemHM.notHM
	and a
	ret

; sets carry if move is an HM, clears carry if move is not an HM
; Input: a = move ID
IsMoveHM:
	ld hl, HMMoves
	ld de, 1
	jp IsInArray

HMMoves:
.INCLUDE "data/moves/hm_moves.asm"

GetMoveName:
	push hl
	ld a, MOVE_NAME
	ld [wNameListType], a
	ld a, [wNamedObjectIndex]
	ld [wNameListIndex], a
	ld a, bank(MoveNames)
	ld [wPredefBank], a
	call GetName
	ld de, wNameBuffer
	pop hl
	ret
