; Structured replacement for SlotMachine_PrintPayoutCoins.
SlotMachine_PrintPayoutCoins:
	ld hl, wTileMap + (1 * 20) + 11
	ld de, wPayoutCoins
	ld bc, (($80 | 2) << 8) | 4
	jp PrintNumber
SlotMachinePrintPayoutCoinsEnd:
