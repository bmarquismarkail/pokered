SlotReward300Func:
	LD HL, YeahText
	CALL PrintText
	LD A, SFX_GET_ITEM_2
	CALL PlaySound
	CALL Random
	CP $80
	LD A, 0
	JR C, SlotReward300Func.skip
	LD (wSlotMachineFlags), A
SlotReward300Func.skip:
	LD (wSlotMachineAllowMatchesCounter), A
	LD B, $14
	LD DE, 300
	RET
SlotReward300FuncEnd:
