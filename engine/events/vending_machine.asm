VendingMachineMenu:
	ld hl, VendingMachineText1
	call PrintText
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, 3
	ld [wMaxMenuItem], a
	ld a, 5
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 0, 3
	ld b, 8
	ld c, 12
	call TextBoxBorder
	call UpdateSprites
	hlcoord 2, 5
	ld de, DrinkText
	call PlaceString
	hlcoord 9, 6
	ld de, DrinkPriceText
	call PlaceString
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, VendingMachineMenu.notThirsty
	ld a, [wCurrentMenuItem]
	cp 3 ; chose Cancel?
	jr z, VendingMachineMenu.notThirsty
	xor a
	ldh [lobyte(hMoney)], a
	ldh [lobyte(hMoney + 2)], a
	ld a, $2
	ldh [lobyte(hMoney + 1)], a
	call HasEnoughMoney
	jr nc, VendingMachineMenu.enoughMoney
	ld hl, VendingMachineText4
	jp PrintText
VendingMachineMenu.enoughMoney
	call LoadVendingMachineItem
	ldh a, [lobyte(hVendingMachineItem)]
	ld b, a
	ld c, 1
	call GiveItem
	jr nc, VendingMachineMenu.BagFull

	ld b, 60 ; number of times to play the "brrrrr" sound
VendingMachineMenu.playDeliverySound
	ld c, 2
	call DelayFrames
	push bc
	ld a, SFX_PUSH_BOULDER
	call PlaySound
	pop bc
	dec b
	jr nz, VendingMachineMenu.playDeliverySound

	ld hl, VendingMachineText5
	call PrintText
	ld hl, hVendingMachinePrice + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	jp DisplayTextBoxID
VendingMachineMenu.BagFull
	ld hl, VendingMachineText6
	jp PrintText
VendingMachineMenu.notThirsty
	ld hl, VendingMachineText7
	jp PrintText

VendingMachineText1:
	text_far WLA_GLOBAL_VendingMachineText1
	text_end

DrinkText:
		.STRINGMAP pokemon, "FRESH WATER"
	next "SODA POP"
	next "LEMONADE"
	next "CANCEL@"

DrinkPriceText:
		.STRINGMAP pokemon, "¥200"
	next "¥300"
	next "¥350"
	next "@"

VendingMachineText4:
	text_far WLA_GLOBAL_VendingMachineText4
	text_end

VendingMachineText5:
	text_far WLA_GLOBAL_VendingMachineText5
	text_end

VendingMachineText6:
	text_far WLA_GLOBAL_VendingMachineText6
	text_end

VendingMachineText7:
	text_far WLA_GLOBAL_VendingMachineText7
	text_end

LoadVendingMachineItem:
	ld hl, VendingPrices
	ld a, [wCurrentMenuItem]
	add a
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]
	ldh [lobyte(hVendingMachineItem)], a
	ld a, [hli]
	ldh [lobyte(hVendingMachinePrice)], a
	ld a, [hli]
	ldh [lobyte(hVendingMachinePrice + 1)], a
	ld a, [hl]
	ldh [lobyte(hVendingMachinePrice + 2)], a
	ret

.INCLUDE "data/items/vending_prices.asm"
