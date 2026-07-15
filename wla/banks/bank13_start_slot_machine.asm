; Structured replacement for engine/slots/game_corner_slots.asm.
+StartSlotMachine:
	ld a, (wHiddenEventFunctionArgument)
	cp SLOTS_OUTOFORDER
	jr z, StartSlotMachine.printOutOfOrder
	cp SLOTS_OUTTOLUNCH
	jr z, StartSlotMachine.printOutToLunch
	cp SLOTS_SOMEONESKEYS
	jr z, StartSlotMachine.printSomeonesKeys
	ld b, $0b
	ld hl, $7f09
	call Bankswitch
	ld a, (wCanPlaySlots)
	and a
	ret z
	ld a, (wLuckySlotHiddenEventIndex)
	ld b, a
	ld a, (wHiddenEventIndex)
	inc a
	cp b
	jr z, StartSlotMachine.match
	ld a, 253
	jr StartSlotMachine.next
StartSlotMachine.match:
	ld a, 250
StartSlotMachine.next:
	ld (wSlotMachineSevenAndBarModeChance), a
	ldh a, (hLoadedROMBank - $FF00)
	ld (wSlotMachineSavedROMBank), a
	call PromptUserToPlaySlots
	ret
StartSlotMachine.printOutOfOrder:
	ld a, $28
	jr StartSlotMachine.printText
StartSlotMachine.printOutToLunch:
	ld a, $29
	jr StartSlotMachine.printText
StartSlotMachine.printSomeonesKeys:
	ld a, $2a
StartSlotMachine.printText:
	push af
	call EnableAutoTextBoxDrawing
	pop af
	call PrintPredefTextID
	ret

GameCornerOutOfOrderText:
	.DB $17
	.DW $4b8f
	.DB $22
	.DB $50

GameCornerOutToLunchText:
	.DB $17
	.DW $4bad
	.DB $22
	.DB $50

GameCornerSomeonesKeysText:
	.DB $17
	.DW $4bcd
	.DB $22
	.DB $50
StartSlotMachineEnd:
