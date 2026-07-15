; Structured replacement for SlotMachine_PrintCreditCoins.
SlotMachine_PrintCreditCoins:
	ld hl, wTileMap + (1 * 20) + 5
	ld de, wPlayerCoins
	ld c, 2
	jp PrintBCDNumber
SlotMachinePrintCreditCoinsEnd:
