; Structured replacement for SlotMachine_PrintWinningSymbol.
SlotMachine_PrintWinningSymbol:
	ld hl, wTileMap + (14 * 20) + 2
	ld a, (wSlotMachineWinningSymbol)
	add $25
	ld (HL+), a
	inc a
	ld (HL-), a
	inc a
	ld de, -20
	add hl, de
	ld (HL+), a
	inc a
	ld (hl), a
	ld hl, wTileMap + (16 * 20) + 18
	ld (hl), $ee
	ret
SlotMachinePrintWinningSymbolEnd:
