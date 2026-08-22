DisableLCD:
	xor a
	ldh [lobyte(rIF)], a
	ldh a, [lobyte(rIE)]
	ld b, a
	res B_IE_VBLANK, a
	ldh [lobyte(rIE)], a

DisableLCD.wait
	ldh a, [lobyte(rLY)]
	cp LY_VBLANK + 1
	jr nz, DisableLCD.wait

	ldh a, [lobyte(rLCDC)]
	and ~LCDC_ON
	ldh [lobyte(rLCDC)], a
	ld a, b
	ldh [lobyte(rIE)], a
	ret

EnableLCD:
	ldh a, [lobyte(rLCDC)]
	set B_LCDC_ENABLE, a
	ldh [lobyte(rLCDC)], a
	ret
