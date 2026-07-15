SlotReward100Func:
	LD A, SFX_GET_KEY_ITEM
	CALL PlaySound
	XOR A
	LD (wSlotMachineFlags), A
	LD B, $8
	LD DE, 100
	RET
SlotReward100FuncEnd:
