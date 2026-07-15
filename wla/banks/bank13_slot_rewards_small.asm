SlotReward8Func:
	LD HL, wSlotMachineAllowMatchesCounter
	LD A, (HL)
	AND A
	JR Z, SlotReward8Func.skip
	DEC (HL)
SlotReward8Func.skip:
	LD B, $2
	LD DE, 8
	RET
SlotReward8FuncEnd:
SlotReward15Func:
	LD HL, wSlotMachineAllowMatchesCounter
	LD A, (HL)
	AND A
	JR Z, SlotReward15Func.skip
	DEC (HL)
SlotReward15Func.skip:
	LD B, $4
	LD DE, 15
	RET
SlotReward15FuncEnd:
