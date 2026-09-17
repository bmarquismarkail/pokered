Random_:
; Generate a random 16-bit value.
	ldh a, [lobyte(rDIV)]
	ld b, a
	ldh a, [lobyte(hRandomAdd)]
	adc b
	ldh [lobyte(hRandomAdd)], a
	ldh a, [lobyte(rDIV)]
	ld b, a
	ldh a, [lobyte(hRandomSub)]
	sbc b
	ldh [lobyte(hRandomSub)], a
	ret
