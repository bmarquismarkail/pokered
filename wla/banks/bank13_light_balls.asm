; Structured replacement for SlotMachine_LightBalls.
SlotMachine_LightBalls:
	ld a, $14
	ld (wNewSlotMachineBallTile), a
	ld a, (wSlotMachineBet)
	dec a
	.DB $28, $1b, $3d, $28, $0c
SlotMachineLightBallsEnd:
