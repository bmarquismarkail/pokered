; divide hMoney by hDivideBCDDivisor
; return output in hDivideBCDQuotient (same as hDivideBCDDivisor)
; used only to halve player money upon losing a fight
DivideBCDPredef:
DivideBCDPredef2:
DivideBCDPredef3: ; only used function
DivideBCDPredef4:
	call GetPredefRegisters

DivideBCD:
	xor a
	ldh [lobyte(hDivideBCDBuffer)], a
	ldh [lobyte(hDivideBCDBuffer+1)], a
	ldh [lobyte(hDivideBCDBuffer+2)], a
	ld d, $1
DivideBCD.mulBy10Loop
; multiply the divisor by 10 until the leading digit is nonzero
; to set up the standard long division algorithm
	ldh a, [lobyte(hDivideBCDDivisor)]
	and $f0
	jr nz, DivideBCD.next
	inc d
	ldh a, [lobyte(hDivideBCDDivisor)]
	swap a
	and $f0
	ld b, a
	ldh a, [lobyte(hDivideBCDDivisor+1)]
	swap a
	ldh [lobyte(hDivideBCDDivisor+1)], a
	and $f
	or b
	ldh [lobyte(hDivideBCDDivisor)], a
	ldh a, [lobyte(hDivideBCDDivisor+1)]
	and $f0
	ld b, a
	ldh a, [lobyte(hDivideBCDDivisor+2)]
	swap a
	ldh [lobyte(hDivideBCDDivisor+2)], a
	and $f
	or b
	ldh [lobyte(hDivideBCDDivisor+1)], a
	ldh a, [lobyte(hDivideBCDDivisor+2)]
	and $f0
	ldh [lobyte(hDivideBCDDivisor+2)], a
	jr DivideBCD.mulBy10Loop

DivideBCD.next
	push de
	push de
	call DivideBCD_getNextDigit
	pop de
	ld a, b
	swap a
	and $f0
	ldh [lobyte(hDivideBCDBuffer)], a
	dec d
	jr z, DivideBCD.next2
	push de
	call DivideBCD_divDivisorBy10
	call DivideBCD_getNextDigit
	pop de
	ldh a, [lobyte(hDivideBCDBuffer)]
	or b
	ldh [lobyte(hDivideBCDBuffer)], a
	dec d
	jr z, DivideBCD.next2
	push de
	call DivideBCD_divDivisorBy10
	call DivideBCD_getNextDigit
	pop de
	ld a, b
	swap a
	and $f0
	ldh [lobyte(hDivideBCDBuffer+1)], a
	dec d
	jr z, DivideBCD.next2
	push de
	call DivideBCD_divDivisorBy10
	call DivideBCD_getNextDigit
	pop de
	ldh a, [lobyte(hDivideBCDBuffer+1)]
	or b
	ldh [lobyte(hDivideBCDBuffer+1)], a
	dec d
	jr z, DivideBCD.next2
	push de
	call DivideBCD_divDivisorBy10
	call DivideBCD_getNextDigit
	pop de
	ld a, b
	swap a
	and $f0
	ldh [lobyte(hDivideBCDBuffer+2)], a
	dec d
	jr z, DivideBCD.next2
	push de
	call DivideBCD_divDivisorBy10
	call DivideBCD_getNextDigit
	pop de
	ldh a, [lobyte(hDivideBCDBuffer+2)]
	or b
	ldh [lobyte(hDivideBCDBuffer+2)], a
DivideBCD.next2
	ldh a, [lobyte(hDivideBCDBuffer)]
	ldh [lobyte(hDivideBCDQuotient)], a ; the same memory location as hDivideBCDDivisor
	ldh a, [lobyte(hDivideBCDBuffer+1)]
	ldh [lobyte(hDivideBCDQuotient+1)], a
	ldh a, [lobyte(hDivideBCDBuffer+2)]
	ldh [lobyte(hDivideBCDQuotient+2)], a
	pop de
	ld a, $6
	sub d
	and a
	ret z
DivideBCD.divResultBy10loop
	push af
	call DivideBCD_divDivisorBy10
	pop af
	dec a
	jr nz, DivideBCD.divResultBy10loop
	ret

DivideBCD_divDivisorBy10:
	ldh a, [lobyte(hDivideBCDDivisor+2)]
	swap a
	and $f
	ld b, a
	ldh a, [lobyte(hDivideBCDDivisor+1)]
	swap a
	ldh [lobyte(hDivideBCDDivisor+1)], a
	and $f0
	or b
	ldh [lobyte(hDivideBCDDivisor+2)], a
	ldh a, [lobyte(hDivideBCDDivisor+1)]
	and $f
	ld b, a
	ldh a, [lobyte(hDivideBCDDivisor)]
	swap a
	ldh [lobyte(hDivideBCDDivisor)], a
	and $f0
	or b
	ldh [lobyte(hDivideBCDDivisor+1)], a
	ldh a, [lobyte(hDivideBCDDivisor)]
	and $f
	ldh [lobyte(hDivideBCDDivisor)], a
	ret

DivideBCD_getNextDigit:
	ld bc, $3
DivideBCD_getNextDigit.loop
	ld de, hMoney ; the dividend
	ld hl, hDivideBCDDivisor
	push bc
	call StringCmp
	pop bc
	ret c
	inc b
	ld de, hMoney + 2 ; since SubBCD works starting from the least significant digit
	ld hl, hDivideBCDDivisor + 2
	push bc
	call SubBCD
	pop bc
	jr DivideBCD_getNextDigit.loop


AddBCDPredef:
	call GetPredefRegisters

AddBCD:
	and a
	ld b, c
AddBCD.add
	ld a, [de]
	adc [hl]
	daa
	ld [de], a
	dec de
	dec hl
	dec c
	jr nz, AddBCD.add
	jr nc, AddBCD.done
	ld a, $99
	inc de
AddBCD.fill
	ld [de], a
	inc de
	dec b
	jr nz, AddBCD.fill
AddBCD.done
	ret


SubBCDPredef:
	call GetPredefRegisters

SubBCD:
	and a
	ld b, c
SubBCD.sub
	ld a, [de]
	sbc [hl]
	daa
	ld [de], a
	dec de
	dec hl
	dec c
	jr nz, SubBCD.sub
	jr nc, SubBCD.done
	ld a, $00
	inc de
SubBCD.fill
	ld [de], a
	inc de
	dec b
	jr nz, SubBCD.fill
	scf
SubBCD.done
	ret
