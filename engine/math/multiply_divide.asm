_Multiply:
WLA_GLOBAL_Multiply:
	ld a, $8
	ld b, a
	xor a
	ldh [lobyte(hProduct)], a
	ldh [lobyte(hMultiplyBuffer)], a
	ldh [lobyte(hMultiplyBuffer+1)], a
	ldh [lobyte(hMultiplyBuffer+2)], a
	ldh [lobyte(hMultiplyBuffer+3)], a
_Multiply.loop:
WLA_GLOBAL_Multiply__loop:
	ldh a, [lobyte(hMultiplier)]
	srl a
	ldh [lobyte(hMultiplier)], a ; (aliases: hDivisor, hMultiplier, hPowerOf10)
	jr nc, WLA_GLOBAL_Multiply__smallMultiplier
	ldh a, [lobyte(hMultiplyBuffer+3)]
	ld c, a
	ldh a, [lobyte(hMultiplicand+2)]
	add c
	ldh [lobyte(hMultiplyBuffer+3)], a
	ldh a, [lobyte(hMultiplyBuffer+2)]
	ld c, a
	ldh a, [lobyte(hMultiplicand+1)]
	adc c
	ldh [lobyte(hMultiplyBuffer+2)], a
	ldh a, [lobyte(hMultiplyBuffer+1)]
	ld c, a
	ldh a, [lobyte(hMultiplicand)] ; (aliases: hMultiplicand)
	adc c
	ldh [lobyte(hMultiplyBuffer+1)], a
	ldh a, [lobyte(hMultiplyBuffer)]
	ld c, a
	ldh a, [lobyte(hProduct)] ; (aliases: hProduct, hPastLeadingZeros, hQuotient)
	adc c
	ldh [lobyte(hMultiplyBuffer)], a
_Multiply.smallMultiplier:
WLA_GLOBAL_Multiply__smallMultiplier:
	dec b
	jr z, WLA_GLOBAL_Multiply__done
	ldh a, [lobyte(hMultiplicand+2)]
	sla a
	ldh [lobyte(hMultiplicand+2)], a
	ldh a, [lobyte(hMultiplicand+1)]
	rl a
	ldh [lobyte(hMultiplicand+1)], a
	ldh a, [lobyte(hMultiplicand)]
	rl a
	ldh [lobyte(hMultiplicand)], a
	ldh a, [lobyte(hProduct)]
	rl a
	ldh [lobyte(hProduct)], a
	jr WLA_GLOBAL_Multiply__loop
_Multiply.done:
WLA_GLOBAL_Multiply__done:
	ldh a, [lobyte(hMultiplyBuffer+3)]
	ldh [lobyte(hProduct+3)], a
	ldh a, [lobyte(hMultiplyBuffer+2)]
	ldh [lobyte(hProduct+2)], a
	ldh a, [lobyte(hMultiplyBuffer+1)]
	ldh [lobyte(hProduct+1)], a
	ldh a, [lobyte(hMultiplyBuffer)]
	ldh [lobyte(hProduct)], a
	ret

_Divide:
WLA_GLOBAL_Divide:
	xor a
	ldh [lobyte(hDivideBuffer)], a
	ldh [lobyte(hDivideBuffer+1)], a
	ldh [lobyte(hDivideBuffer+2)], a
	ldh [lobyte(hDivideBuffer+3)], a
	ldh [lobyte(hDivideBuffer+4)], a
	ld a, $9
	ld e, a
_Divide.loop:
WLA_GLOBAL_Divide__loop:
	ldh a, [lobyte(hDivideBuffer)]
	ld c, a
	ldh a, [lobyte(hDividend+1)] ; (aliases: hMultiplicand)
	sub c
	ld d, a
	ldh a, [lobyte(hDivisor)] ; (aliases: hDivisor, hMultiplier, hPowerOf10)
	ld c, a
	ldh a, [lobyte(hDividend)] ; (aliases: hProduct, hPastLeadingZeros, hQuotient)
	sbc c
	jr c, WLA_GLOBAL_Divide__next
	ldh [lobyte(hDividend)], a ; (aliases: hProduct, hPastLeadingZeros, hQuotient)
	ld a, d
	ldh [lobyte(hDividend+1)], a ; (aliases: hMultiplicand)
	ldh a, [lobyte(hDivideBuffer+4)]
	inc a
	ldh [lobyte(hDivideBuffer+4)], a
	jr WLA_GLOBAL_Divide__loop
_Divide.next:
WLA_GLOBAL_Divide__next:
	ld a, b
	cp $1
	jr z, WLA_GLOBAL_Divide__done
	ldh a, [lobyte(hDivideBuffer+4)]
	sla a
	ldh [lobyte(hDivideBuffer+4)], a
	ldh a, [lobyte(hDivideBuffer+3)]
	rl a
	ldh [lobyte(hDivideBuffer+3)], a
	ldh a, [lobyte(hDivideBuffer+2)]
	rl a
	ldh [lobyte(hDivideBuffer+2)], a
	ldh a, [lobyte(hDivideBuffer+1)]
	rl a
	ldh [lobyte(hDivideBuffer+1)], a
	dec e
	jr nz, WLA_GLOBAL_Divide__next2
	ld a, $8
	ld e, a
	ldh a, [lobyte(hDivideBuffer)]
	ldh [lobyte(hDivisor)], a ; (aliases: hDivisor, hMultiplier, hPowerOf10)
	xor a
	ldh [lobyte(hDivideBuffer)], a
	ldh a, [lobyte(hDividend+1)] ; (aliases: hMultiplicand)
	ldh [lobyte(hDividend)], a ; (aliases: hProduct, hPastLeadingZeros, hQuotient)
	ldh a, [lobyte(hDividend+2)]
	ldh [lobyte(hDividend+1)], a ; (aliases: hMultiplicand)
	ldh a, [lobyte(hDividend+3)]
	ldh [lobyte(hDividend+2)], a
_Divide.next2:
WLA_GLOBAL_Divide__next2:
	ld a, e
	cp $1
	jr nz, WLA_GLOBAL_Divide__okay
	dec b
_Divide.okay:
WLA_GLOBAL_Divide__okay:
	ldh a, [lobyte(hDivisor)] ; (aliases: hDivisor, hMultiplier, hPowerOf10)
	srl a
	ldh [lobyte(hDivisor)], a ; (aliases: hDivisor, hMultiplier, hPowerOf10)
	ldh a, [lobyte(hDivideBuffer)]
	rr a
	ldh [lobyte(hDivideBuffer)], a
	jr WLA_GLOBAL_Divide__loop
_Divide.done:
WLA_GLOBAL_Divide__done:
	ldh a, [lobyte(hDividend+1)] ; (aliases: hMultiplicand)
	ldh [lobyte(hRemainder)], a ; (aliases: hDivisor, hMultiplier, hPowerOf10)
	ldh a, [lobyte(hDivideBuffer+4)]
	ldh [lobyte(hQuotient+3)], a
	ldh a, [lobyte(hDivideBuffer+3)]
	ldh [lobyte(hQuotient+2)], a
	ldh a, [lobyte(hDivideBuffer+2)]
	ldh [lobyte(hQuotient+1)], a ; (aliases: hMultiplicand)
	ldh a, [lobyte(hDivideBuffer+1)]
	ldh [lobyte(hDividend)], a ; (aliases: hProduct, hPastLeadingZeros, hQuotient)
	ret
