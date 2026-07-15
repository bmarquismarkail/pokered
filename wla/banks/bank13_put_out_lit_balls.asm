; Structured replacement for SlotMachine_PutOutLitBalls.
SlotMachine_PutOutLitBalls:
	ld a, $23
	ld (wNewSlotMachineBallTile), a
	.DB $18, $0e
SlotMachinePutOutLitBallsEnd:
