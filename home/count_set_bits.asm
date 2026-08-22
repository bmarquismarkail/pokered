; function to count how many bits are set in a string of bytes
; INPUT:
; hl = address of string of bytes
; b = length of string of bytes
; OUTPUT:
; [wNumSetBits] = number of set bits
CountSetBits:
	ld c, 0
CountSetBits.loop
	ld a, [hli]
	ld e, a
	ld d, 8
CountSetBits.innerLoop ; count how many bits are set in the current byte
	srl e
	ld a, 0
	adc c
	ld c, a
	dec d
	jr nz, CountSetBits.innerLoop
	dec b
	jr nz, CountSetBits.loop
	ld a, c
	ld [wNumSetBits], a
	ret
