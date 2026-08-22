; b = new color for BG color 0 (usually white) for 4 frames
ChangeBGPalColor0_4Frames:
	call GetPredefRegisters
	ldh a, [lobyte(rBGP)]
	or b
	ldh [lobyte(rBGP)], a
	ld c, 4
	call DelayFrames
	ldh a, [lobyte(rBGP)]
	and %11111100
	ldh [lobyte(rBGP)], a
	ret

PredefShakeScreenVertically:
; Moves the window down and then back in a sequence of progressively smaller
; numbers of pixels, starting at b.
	call GetPredefRegisters
	ld a, 1
	ld [wDisableVBlankWYUpdate], a
	xor a
PredefShakeScreenVertically.loop
	ldh [lobyte(hMutateWY)], a
	call PredefShakeScreenVertically.MutateWY
	call PredefShakeScreenVertically.MutateWY
	dec b
	ld a, b
	jr nz, PredefShakeScreenVertically.loop
	xor a
	ld [wDisableVBlankWYUpdate], a
	ret

PredefShakeScreenVertically.MutateWY
	ldh a, [lobyte(hMutateWY)]
	xor b
	ldh [lobyte(hMutateWY)], a
	ldh [lobyte(rWY)], a
	ld c, 3
	jp DelayFrames

PredefShakeScreenHorizontally:
; Moves the window right and then back in a sequence of progressively smaller
; numbers of pixels, starting at b.
	call GetPredefRegisters
	xor a
PredefShakeScreenHorizontally.loop
	ldh [lobyte(hMutateWX)], a
	call PredefShakeScreenHorizontally.MutateWX
	ld c, 1
	call DelayFrames
	call PredefShakeScreenHorizontally.MutateWX
	dec b
	ld a, b
	jr nz, PredefShakeScreenHorizontally.loop

; restore normal WX
	ld a, 7
	ldh [lobyte(rWX)], a
	ret

PredefShakeScreenHorizontally.MutateWX
	ldh a, [lobyte(hMutateWX)]
	xor b
	ldh [lobyte(hMutateWX)], a
	bit 7, a ; negative?
	jr z, PredefShakeScreenHorizontally.skipZeroing
	xor a ; zero a if it's negative
PredefShakeScreenHorizontally.skipZeroing
	add 7
	ldh [lobyte(rWX)], a
	ld c, 4
	jp DelayFrames
