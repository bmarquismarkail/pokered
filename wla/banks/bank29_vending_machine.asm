; Native WLA-DX form of engine/events/vending_machine.asm and its price table.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"

VendingMachineMenu:
	LD HL, VendingMachineText1
	CALL PrintText
	LD A, $13 ; MONEY_BOX
	LD (wTextBoxID), A
	CALL DisplayTextBoxID
	XOR A
	LD (wCurrentMenuItem), A
	LD (wLastMenuItem), A
	LD A, $03 ; PAD_A | PAD_B
	LD (wMenuWatchedKeys), A
	LD A, 3
	LD (wMaxMenuItem), A
	LD A, 5
	LD (wTopMenuItemY), A
	LD A, 1
	LD (wTopMenuItemX), A
	LD HL, wStatusFlags5
	SET 6, (HL) ; BIT_NO_TEXT_DELAY
	LD HL, wTileMap + 3 * 20
	LD B, 8
	LD C, 12
	CALL TextBoxBorder
	CALL UpdateSprites
	LD HL, wTileMap + 5 * 20 + 2
	LD DE, DrinkText
	CALL PlaceString
	LD HL, wTileMap + 6 * 20 + 9
	LD DE, DrinkPriceText
	CALL PlaceString
	LD HL, wStatusFlags5
	RES 6, (HL) ; BIT_NO_TEXT_DELAY
	CALL HandleMenuInput
	BIT 1, A ; B_PAD_B
	JR NZ, VendingMachineMenu.notThirsty
	LD A, (wCurrentMenuItem)
	CP 3
	JR Z, VendingMachineMenu.notThirsty
	XOR A
	LDH ($9f), A ; hMoney
	LDH ($a1), A ; hMoney + 2
	LD A, 2
	LDH ($a0), A ; hMoney + 1
	CALL $35a6 ; HasEnoughMoney
	JR NC, VendingMachineMenu.enoughMoney
	LD HL, VendingMachineText4
	JP PrintText
VendingMachineMenu.enoughMoney:
	CALL LoadVendingMachineItem
	LDH A, ($db) ; hVendingMachineItem
	LD B, A
	LD C, 1
	CALL $3e2e ; GiveItem
	JR NC, VendingMachineMenu.BagFull
	LD B, 60
VendingMachineMenu.playDeliverySound:
	LD C, 2
	CALL DelayFrames
	PUSH BC
	LD A, $a8 ; SFX_PUSH_BOULDER
	CALL PlaySound
	POP BC
	DEC B
	JR NZ, VendingMachineMenu.playDeliverySound
	LD HL, VendingMachineText5
	CALL PrintText
	LD HL, $ffde ; hVendingMachinePrice + 2
	LD DE, wPlayerMoney + 2
	LD C, 3
	LD A, $0c ; SubBCDPredef
	CALL Predef
	LD A, $13 ; MONEY_BOX
	LD (wTextBoxID), A
	JP DisplayTextBoxID
VendingMachineMenu.BagFull:
	LD HL, VendingMachineText6
	JP PrintText
VendingMachineMenu.notThirsty:
	LD HL, VendingMachineText7
	JP PrintText

VendingMachineText1:
	.DB $17
	.DW $4e72
	.DB $27, $50
DrinkText:
	.STRINGMAP pokemon, "FRESH WATER"
	.DB $4e
	.STRINGMAP pokemon, "SODA POP"
	.DB $4e
	.STRINGMAP pokemon, "LEMONADE"
	.DB $4e
	.STRINGMAP pokemon, "CANCEL"
	.DB $50
DrinkPriceText:
	.STRINGMAP pokemon, "¥200"
	.DB $4e
	.STRINGMAP pokemon, "¥300"
	.DB $4e
	.STRINGMAP pokemon, "¥350"
	.DB $4e, $50
VendingMachineText4:
	.DB $17
	.DW $4e96
	.DB $27, $50
VendingMachineText5:
	.DB $17
	.DW $4eaf
	.DB $27, $50
VendingMachineText6:
	.DB $17
	.DW $4ec0
	.DB $27, $50
VendingMachineText7:
	.DB $17
	.DW $4ee0
	.DB $27, $50

LoadVendingMachineItem:
	LD HL, VendingPrices
	LD A, (wCurrentMenuItem)
	ADD A
	ADD A
	LD D, 0
	LD E, A
	ADD HL, DE
	LD A, (HL+)
	LDH ($db), A ; hVendingMachineItem
	LD A, (HL+)
	LDH ($dc), A ; hVendingMachinePrice
	LD A, (HL+)
	LDH ($dd), A
	LD A, (HL)
	LDH ($de), A
	RET

VendingPrices:
	.DB $3c, $00, $02, $00 ; FRESH_WATER, ¥200
	.DB $3d, $00, $03, $00 ; SODA_POP, ¥300
	.DB $3e, $00, $03, $50 ; LEMONADE, ¥350
VendingMachineEnd:
