StartSlotMachine:
	ld a, [wHiddenEventFunctionArgument]
	cp SLOTS_OUTOFORDER
	jr z, StartSlotMachine.printOutOfOrder
	cp SLOTS_OUTTOLUNCH
	jr z, StartSlotMachine.printOutToLunch
	cp SLOTS_SOMEONESKEYS
	jr z, StartSlotMachine.printSomeonesKeys
	farcall AbleToPlaySlotsCheck
	ld a, [wCanPlaySlots]
	and a
	ret z
	ld a, [wLuckySlotHiddenEventIndex]
	ld b, a
	ld a, [wHiddenEventIndex]
	inc a
	cp b
	jr z, StartSlotMachine.match
	ld a, 253
	jr StartSlotMachine.next
StartSlotMachine.match
	ld a, 250
StartSlotMachine.next
	ld [wSlotMachineSevenAndBarModeChance], a
	ldh a, [lobyte(hLoadedROMBank)]
	ld [wSlotMachineSavedROMBank], a
	call PromptUserToPlaySlots
	ret
StartSlotMachine.printOutOfOrder
	tx_pre_id GameCornerOutOfOrderText
	jr StartSlotMachine.printText
StartSlotMachine.printOutToLunch
	tx_pre_id GameCornerOutToLunchText
	jr StartSlotMachine.printText
StartSlotMachine.printSomeonesKeys
	tx_pre_id GameCornerSomeonesKeysText
StartSlotMachine.printText
	push af
	call EnableAutoTextBoxDrawing
	pop af
	call PrintPredefTextID
	ret

GameCornerOutOfOrderText:
	text_far WLA_GLOBAL_GameCornerOutOfOrderText
	text_end

GameCornerOutToLunchText:
	text_far WLA_GLOBAL_GameCornerOutToLunchText
	text_end

GameCornerSomeonesKeysText:
	text_far WLA_GLOBAL_GameCornerSomeonesKeysText
	text_end
