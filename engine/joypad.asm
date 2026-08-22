JoypadCore:
_Joypad:
WLA_GLOBAL_Joypad:
; hJoyReleased: (hJoyLast ^ hJoyInput) & hJoyLast
; hJoyPressed:  (hJoyLast ^ hJoyInput) & hJoyInput

	ldh a, [lobyte(hJoyInput)]
	cp PAD_BUTTONS ; soft reset
	jp z, TrySoftReset

	ld b, a
	ldh a, [lobyte(hJoyLast)]
	ld e, a
	xor b
	ld d, a
	and e
	ldh [lobyte(hJoyReleased)], a
	ld a, d
	and b
	ldh [lobyte(hJoyPressed)], a
	ld a, b
	ldh [lobyte(hJoyLast)], a

	ld a, [wStatusFlags5]
	bit BIT_DISABLE_JOYPAD, a
	jr nz, DiscardButtonPresses

	ldh a, [lobyte(hJoyLast)]
	ldh [lobyte(hJoyHeld)], a

	ld a, [wJoyIgnore]
	and a
	ret z

	cpl
	ld b, a
	ldh a, [lobyte(hJoyHeld)]
	and b
	ldh [lobyte(hJoyHeld)], a
	ldh a, [lobyte(hJoyPressed)]
	and b
	ldh [lobyte(hJoyPressed)], a
	ret

DiscardButtonPresses:
	xor a
	ldh [lobyte(hJoyHeld)], a
	ldh [lobyte(hJoyPressed)], a
	ldh [lobyte(hJoyReleased)], a
	ret

TrySoftReset:
	call DelayFrame

	; deselect (redundant)
	ld a, $30
	ldh [lobyte(rJOYP)], a

	ld hl, hSoftReset
	dec [hl]
	jp z, SoftReset

	jp Joypad
