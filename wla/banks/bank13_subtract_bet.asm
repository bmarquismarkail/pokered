SlotMachine_SubtractBetFromPlayerCoins:
	LD HL, wTempCoins2 + 1
	LD A, (wSlotMachineBet)
	LD (HL-), A
	XOR A
	LD (HL+), A
	LD DE, wPlayerCoins + 1
	LD C, $2
	LD A, $0C
	CALL Predef
SlotMachine_SubtractBetFromPlayerCoinsEnd:
