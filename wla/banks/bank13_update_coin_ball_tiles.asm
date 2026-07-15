SlotMachine_UpdateThreeCoinBallTiles:
	LD HL, wTileMap + (2 * 20) + 3
	CALL SlotMachine_UpdateBallTiles
	LD HL, wTileMap + (10 * 20) + 3
	CALL SlotMachine_UpdateBallTiles
SlotMachine_UpdateTwoCoinBallTiles:
	LD HL, wTileMap + (4 * 20) + 3
	CALL SlotMachine_UpdateBallTiles
	LD HL, wTileMap + (8 * 20) + 3
	CALL SlotMachine_UpdateBallTiles
SlotMachine_UpdateOneCoinBallTiles:
	LD HL, wTileMap + (6 * 20) + 3
SlotMachine_UpdateBallTiles:
	LD A, (wNewSlotMachineBallTile)
	LD (HL), A
	LD BC, 13
	ADD HL, BC
	LD (HL), A
	LD BC, 7
	ADD HL, BC
	INC A
	LD (HL), A
	LD BC, 13
	ADD HL, BC
	LD (HL), A
	RET
SlotMachine_UpdateBallTilesEnd:
