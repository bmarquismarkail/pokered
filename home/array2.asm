CallFunctionInTable:
; Call function a in jumptable hl.
; de is not preserved.
	push hl
	push de
	push bc
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, CallFunctionInTable.returnAddress
	push de
	jp hl
CallFunctionInTable.returnAddress
	pop bc
	pop de
	pop hl
	ret

IsInArray:
; Search an array at hl for the value in a.
; Entry size is de bytes.
; Return count b and carry if found.
	ld b, 0

IsInRestOfArray:
	ld c, a
IsInRestOfArray.loop
	ld a, [hl]
	cp -1
	jr z, IsInRestOfArray.notfound
	cp c
	jr z, IsInRestOfArray.found
	inc b
	add hl, de
	jr IsInRestOfArray.loop

IsInRestOfArray.notfound
	and a
	ret

IsInRestOfArray.found
	scf
	ret
