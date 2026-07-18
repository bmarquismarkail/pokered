ViridianGymPlayerSpinningScript:
	LD A, ($CD38) ; wSimulatedJoypadStatesIndex
	AND A
	JR NZ, ViridianGymPlayerSpinningScript.ViridianGymLoadSpinnerArrow
	XOR A
	LD ($CD6B), A ; wJoyIgnore
	LD HL, $D736
	RES 7, (HL) ; BIT_SPINNING
	LD A, 0
	LD ($DA39), A
	RET
ViridianGymPlayerSpinningScript.ViridianGymLoadSpinnerArrow:
	LD B, $11
	LD HL, $4FD7 ; LoadSpinnerArrowTiles
	JP $35D6 ; Bankswitch
ViridianGymSpinnerRuntimeEnd:
.ASSERT ViridianGymSpinnerRuntimeEnd - ViridianGymPlayerSpinningScript == 29
