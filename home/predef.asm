Predef:
; Call predefined function a.
; To preserve other registers, have the
; destination call GetPredefRegisters.

	; Save the predef id for GetPredefPointer.
	ld [wPredefID], a

	; A hack for LoadDestinationWarpPosition.
	; See LoadTilesetHeader (predef $19).
	ldh a, [lobyte(hLoadedROMBank)]
	ld [wPredefParentBank], a

	push af
	ld a, bank(GetPredefPointer)
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a

	call GetPredefPointer

	ld a, [wPredefBank]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a

	ld de, Predef.done
	push de
	jp hl
Predef.done

	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret

GetPredefRegisters:
; Restore the contents of register pairs
; when GetPredefPointer was called.
	ld a, [wPredefHL]
	ld h, a
	ld a, [wPredefHL + 1]
	ld l, a
	ld a, [wPredefDE]
	ld d, a
	ld a, [wPredefDE + 1]
	ld e, a
	ld a, [wPredefBC]
	ld b, a
	ld a, [wPredefBC + 1]
	ld c, a
	ret
