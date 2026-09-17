PrintNumber:
; Print the c-digit, b-byte value at de.
; Allows 2 to 7 digits. For 1-digit numbers, add
; the value to char "0" instead of calling PrintNumber.
; Flags LEADING_ZEROES and LEFT_ALIGN can be given
; in bits 7 and 6 of b respectively.
	push bc
	xor a
	ldh [lobyte(hPastLeadingZeros)], a
	ldh [lobyte(hNumToPrint)], a
	ldh [lobyte(hNumToPrint + 1)], a
	ld a, b
	and $f
	cp 1
	jr z, PrintNumber.byte
	cp 2
	jr z, PrintNumber.word
PrintNumber.long
	ld a, [de]
	ldh [lobyte(hNumToPrint)], a
	inc de
	ld a, [de]
	ldh [lobyte(hNumToPrint + 1)], a
	inc de
	ld a, [de]
	ldh [lobyte(hNumToPrint + 2)], a
	jr PrintNumber.start

PrintNumber.word
	ld a, [de]
	ldh [lobyte(hNumToPrint + 1)], a
	inc de
	ld a, [de]
	ldh [lobyte(hNumToPrint + 2)], a
	jr PrintNumber.start

PrintNumber.byte
	ld a, [de]
	ldh [lobyte(hNumToPrint + 2)], a

PrintNumber.start
	push de

	ld d, b
	ld a, c
	ld b, a
	xor a
	ld c, a
	ld a, b

	cp 2
	jr z, PrintNumber.tens
	cp 3
	jr z, PrintNumber.hundreds
	cp 4
	jr z, PrintNumber.thousands
	cp 5
	jr z, PrintNumber.ten_thousands
	cp 6
	jr z, PrintNumber.hundred_thousands

.MACRO print_digit

	.IF (\1) / $10000
		ld a, \1 / $10000 # $100
	.ELSE
		xor a
	.ENDIF
	ldh [lobyte(hPowerOf10 + 0)], a

	.IF (\1) / $100
		ld a, \1 / $100   # $100
	.ELSE
		xor a
	.ENDIF
	ldh [lobyte(hPowerOf10 + 1)], a

	ld a, \1 / $1     # $100
	ldh [lobyte(hPowerOf10 + 2)], a

	call PrintNumber.PrintDigit
	call PrintNumber.NextDigit
.ENDM

; millions
	print_digit 1000000
PrintNumber.hundred_thousands
	print_digit 100000
PrintNumber.ten_thousands
	print_digit 10000
PrintNumber.thousands
	print_digit 1000
PrintNumber.hundreds
	print_digit 100

PrintNumber.tens
	ld c, 0
	ldh a, [lobyte(hNumToPrint + 2)]
PrintNumber.mod
	cp 10
	jr c, PrintNumber.ok
	sub 10
	inc c
	jr PrintNumber.mod
PrintNumber.ok

	ld b, a
	ldh a, [lobyte(hPastLeadingZeros)]
	or c
	ldh [lobyte(hPastLeadingZeros)], a
	jr nz, PrintNumber.past
	call PrintNumber.PrintLeadingZero
	jr PrintNumber.next
PrintNumber.past
	ld a, $f6
	add c
	ld [hl], a
PrintNumber.next

	call PrintNumber.NextDigit
; ones
	ld a, $f6
	add b
	ld [hli], a
	pop de
	dec de
	pop bc
	ret

PrintNumber.PrintDigit:
; Divide by the current decimal place.
; Print the quotient, and keep the modulus.
	ld c, 0
PrintNumber.loop
	ldh a, [lobyte(hPowerOf10)]
	ld b, a
	ldh a, [lobyte(hNumToPrint)]
	ldh [lobyte(hSavedNumToPrint)], a
	cp b
	jr c, PrintNumber.underflow0
	sub b
	ldh [lobyte(hNumToPrint)], a
	ldh a, [lobyte(hPowerOf10 + 1)]
	ld b, a
	ldh a, [lobyte(hNumToPrint + 1)]
	ldh [lobyte(hSavedNumToPrint + 1)], a
	cp b
	jr nc, PrintNumber.noborrow1

	ldh a, [lobyte(hNumToPrint)]
	or 0
	jr z, PrintNumber.underflow1
	dec a
	ldh [lobyte(hNumToPrint)], a
	ldh a, [lobyte(hNumToPrint + 1)]
PrintNumber.noborrow1

	sub b
	ldh [lobyte(hNumToPrint + 1)], a
	ldh a, [lobyte(hPowerOf10 + 2)]
	ld b, a
	ldh a, [lobyte(hNumToPrint + 2)]
	ldh [lobyte(hSavedNumToPrint + 2)], a
	cp b
	jr nc, PrintNumber.noborrow2

	ldh a, [lobyte(hNumToPrint + 1)]
	and a
	jr nz, PrintNumber.borrowed

	ldh a, [lobyte(hNumToPrint)]
	and a
	jr z, PrintNumber.underflow2
	dec a
	ldh [lobyte(hNumToPrint)], a
	xor a
PrintNumber.borrowed

	dec a
	ldh [lobyte(hNumToPrint + 1)], a
	ldh a, [lobyte(hNumToPrint + 2)]
PrintNumber.noborrow2
	sub b
	ldh [lobyte(hNumToPrint + 2)], a
	inc c
	jr PrintNumber.loop

PrintNumber.underflow2
	ldh a, [lobyte(hSavedNumToPrint + 1)]
	ldh [lobyte(hNumToPrint + 1)], a
PrintNumber.underflow1
	ldh a, [lobyte(hSavedNumToPrint)]
	ldh [lobyte(hNumToPrint)], a
PrintNumber.underflow0
	ldh a, [lobyte(hPastLeadingZeros)]
	or c
	jr z, PrintNumber.PrintLeadingZero

	ld a, $f6
	add c
	ld [hl], a
	ldh [lobyte(hPastLeadingZeros)], a
	ret

PrintNumber.PrintLeadingZero:
	bit BIT_LEADING_ZEROES, d
	ret z
	ld [hl], $f6
	ret

PrintNumber.NextDigit:
; Increment unless the number is left-aligned,
; leading zeroes are not printed, and no digits
; have been printed yet.
	bit BIT_LEADING_ZEROES, d
	jr nz, PrintNumber.inc
	bit BIT_LEFT_ALIGN, d
	jr z, PrintNumber.inc
	ldh a, [lobyte(hPastLeadingZeros)]
	and a
	ret z
PrintNumber.inc
	inc hl
	ret
