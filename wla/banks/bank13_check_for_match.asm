SlotMachine_CheckForMatch:
	LD A, (DE)
	CP (HL)
	RET NZ
	LD A, (BC)
	CP (HL)
	RET
SlotMachine_CheckForMatchEnd:
