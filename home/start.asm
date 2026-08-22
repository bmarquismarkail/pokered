_Start:
WLA_GLOBAL_Start:
	cp BOOTUP_A_CGB
	jr z, WLA_GLOBAL_Start__cgb
	xor a
	jr WLA_GLOBAL_Start__ok
_Start.cgb:
WLA_GLOBAL_Start__cgb:
	ld a, FALSE
_Start.ok:
WLA_GLOBAL_Start__ok:
	ld [wOnCGB], a
	jp Init
