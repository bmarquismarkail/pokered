FlagActionPredef:
	call GetPredefRegisters

FlagAction:
; Perform action b on bit c
; in the bitfield at hl.
;  0: reset
;  1: set
;  2: read
; Return the result in c.

	push hl
	push de
	push bc

	; bit
	ld a, c
	ld d, a
	and 7
	ld e, a

	; byte
	ld a, d
	srl a
	srl a
	srl a
	add l
	ld l, a
	jr nc, FlagAction.ok
	inc h
FlagAction.ok

	; d = 1 << e (bitmask)
	inc e
	ld d, 1
FlagAction.shift
	dec e
	jr z, FlagAction.shifted
	sla d
	jr FlagAction.shift
FlagAction.shifted

	ld a, b
	and a
	jr z, FlagAction.reset
	cp FLAG_TEST
	jr z, FlagAction.read

; set
	ld b, [hl]
	ld a, d
	or b
	ld [hl], a
	jr FlagAction.done

FlagAction.reset
	ld b, [hl]
	ld a, d
	xor $ff
	and b
	ld [hl], a
	jr FlagAction.done

FlagAction.read
	ld b, [hl]
	ld a, d
	and b
FlagAction.done
	pop bc
	pop de
	pop hl
	ld c, a
	ret
