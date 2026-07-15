; Structured replacement for LoadSlotMachineTiles.
+LoadSlotMachineTiles:
	call DisableLCD
	ld hl, SlotMachineTiles2
	ld de, vChars0
	ld bc, ($1c * 16) ; should be SlotMachineTiles2End - SlotMachineTiles2, or $18 tiles
	ld a, $1e
	call FarCopyData2
	ld hl, SlotMachineTiles1
	ld de, vChars2
	ld bc, SlotMachineTiles1End - SlotMachineTiles1
	ld a, $0d
	call FarCopyData2
	ld hl, SlotMachineTiles2
	ld de, vChars2 + ($25) * 16
	ld bc, ($1c * 16) ; should be SlotMachineTiles2End - SlotMachineTiles2, or $18 tiles
	ld a, $1e
	call FarCopyData2
	ld hl, SlotMachineMap
	ld de, wTileMap + (0 * 20) + 0
	ld bc, SlotMachineMapEnd - SlotMachineMap
	call CopyData
	call EnableLCD
	ld hl, wSlotMachineWheel1Offset
	ld a, $1c
	ld (HL+), a
	ld (HL+), a
	ld (hl), a
	call SlotMachine_AnimWheel1
	call SlotMachine_AnimWheel2
	jp SlotMachine_AnimWheel3
LoadSlotMachineTilesEnd:
