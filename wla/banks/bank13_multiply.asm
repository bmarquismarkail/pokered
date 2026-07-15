; Structured replacement for engine/math/multiply_divide.asm (_Multiply).
+_Multiply:
	ld a, $8
	ld b, a
	xor a
	ldh (hProduct - $FF00), a
	ldh (hMultiplyBuffer - $FF00), a
	ldh (hMultiplyBuffer - $FF00+1), a
	ldh (hMultiplyBuffer - $FF00+2), a
	ldh (hMultiplyBuffer - $FF00+3), a
_Multiply.loop:
	ldh a, (hMultiplier - $FF00)
	srl a
	ldh (hMultiplier - $FF00), a ; (aliases: hDivisor, hMultiplier, hPowerOf10)
	jr nc, _Multiply.smallMultiplier
	ldh a, (hMultiplyBuffer - $FF00+3)
	ld c, a
	ldh a, (hMultiplicand - $FF00+2)
	add c
	ldh (hMultiplyBuffer - $FF00+3), a
	ldh a, (hMultiplyBuffer - $FF00+2)
	ld c, a
	ldh a, (hMultiplicand - $FF00+1)
	adc c
	ldh (hMultiplyBuffer - $FF00+2), a
	ldh a, (hMultiplyBuffer - $FF00+1)
	ld c, a
	ldh a, (hMultiplicand - $FF00) ; (aliases: hMultiplicand)
	adc c
	ldh (hMultiplyBuffer - $FF00+1), a
	ldh a, (hMultiplyBuffer - $FF00)
	ld c, a
	ldh a, (hProduct - $FF00) ; (aliases: hProduct, hPastLeadingZeros, hQuotient)
	adc c
	ldh (hMultiplyBuffer - $FF00), a
_Multiply.smallMultiplier:
	dec b
	jr z, _Multiply.done
	ldh a, (hMultiplicand - $FF00+2)
	sla a
	ldh (hMultiplicand - $FF00+2), a
	ldh a, (hMultiplicand - $FF00+1)
	rl a
	ldh (hMultiplicand - $FF00+1), a
	ldh a, (hMultiplicand - $FF00)
	rl a
	ldh (hMultiplicand - $FF00), a
	ldh a, (hProduct - $FF00)
	rl a
	ldh (hProduct - $FF00), a
	jr _Multiply.loop
_Multiply.done:
	ldh a, (hMultiplyBuffer - $FF00+3)
	ldh (hProduct - $FF00+3), a
	ldh a, (hMultiplyBuffer - $FF00+2)
	ldh (hProduct - $FF00+2), a
	ldh a, (hMultiplyBuffer - $FF00+1)
	ldh (hProduct - $FF00+1), a
	ldh a, (hMultiplyBuffer - $FF00)
	ldh (hProduct - $FF00), a
	ret
MultiplyEnd:
