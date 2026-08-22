FarCopyData:
; Copy bc bytes from a:hl to de.
	ld [wBuffer], a
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ld a, [wBuffer]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	call CopyData
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret

CopyData:
; Copy bc bytes from hl to de.
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, CopyData
	ret
