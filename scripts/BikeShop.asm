BikeShop_Script:
	jp EnableAutoTextBoxDrawing

BikeShop_TextPointers:
	def_text_pointers
	dw_const BikeShopClerkText,             TEXT_BIKESHOP_CLERK
	dw_const BikeShopMiddleAgedWomanText,   TEXT_BIKESHOP_MIDDLE_AGED_WOMAN
	dw_const BikeShopYoungsterText,         TEXT_BIKESHOP_YOUNGSTER

BikeShopClerkText:
	text_asm
	CheckEvent EVENT_GOT_BICYCLE
	jr z, BikeShopClerkText.dontHaveBike
	ld hl, BikeShopClerkHowDoYouLikeYourBicycleText
	call PrintText
	jp BikeShopClerkText.Done
BikeShopClerkText.dontHaveBike
	ld b, BIKE_VOUCHER
	call IsItemInBag
	jr z, BikeShopClerkText.dontHaveVoucher
	ld hl, BikeShopClerkOhThatsAVoucherText
	call PrintText
	lb "bc", BICYCLE, 1
	call GiveItem
	jr nc, BikeShopClerkText.BagFull
	ld a, BIKE_VOUCHER
	ldh [lobyte(hItemToRemoveID)], a
	farcall RemoveItemByID
	SetEvent EVENT_GOT_BICYCLE
	ld hl, BikeShopExchangedVoucherText
	call PrintText
	jr BikeShopClerkText.Done
BikeShopClerkText.BagFull
	ld hl, BikeShopBagFullText
	call PrintText
	jr BikeShopClerkText.Done
BikeShopClerkText.dontHaveVoucher
	ld hl, BikeShopClerkWelcomeText
	call PrintText
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, $1
	ld [wMaxMenuItem], a
	ld a, $2
	ld [wTopMenuItemY], a
	ld a, $1
	ld [wTopMenuItemX], a
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 0, 0
	ld b, 4
	ld c, 15
	call TextBoxBorder
	call UpdateSprites
	hlcoord 2, 2
	ld de, BikeShopMenuText
	call PlaceString
	hlcoord 8, 3
	ld de, BikeShopMenuPrice
	call PlaceString
	ld hl, BikeShopClerkDoYouLikeItText
	call PrintText
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, BikeShopClerkText.cancel
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ld a, [wCurrentMenuItem]
	and a
	jr nz, BikeShopClerkText.cancel
	ld hl, BikeShopCantAffordText
	call PrintText
BikeShopClerkText.cancel
	ld hl, BikeShopComeAgainText
	call PrintText
BikeShopClerkText.Done
	jp TextScriptEnd

BikeShopMenuText:
		.STRINGMAP pokemon, "BICYCLE"
	next "CANCEL@"

BikeShopMenuPrice:
		.STRINGMAP pokemon, "¥1000000@"

BikeShopClerkWelcomeText:
	text_far WLA_GLOBAL_BikeShopClerkWelcomeText
	text_end

BikeShopClerkDoYouLikeItText:
	text_far WLA_GLOBAL_BikeShopClerkDoYouLikeItText
	text_end

BikeShopCantAffordText:
	text_far WLA_GLOBAL_BikeShopCantAffordText
	text_end

BikeShopClerkOhThatsAVoucherText:
	text_far WLA_GLOBAL_BikeShopClerkOhThatsAVoucherText
	text_end

BikeShopExchangedVoucherText:
	text_far WLA_GLOBAL_BikeShopExchangedVoucherText
	sound_get_key_item
	text_end

BikeShopComeAgainText:
	text_far WLA_GLOBAL_BikeShopComeAgainText
	text_end

BikeShopClerkHowDoYouLikeYourBicycleText:
	text_far WLA_GLOBAL_BikeShopClerkHowDoYouLikeYourBicycleText
	text_end

BikeShopBagFullText:
	text_far WLA_GLOBAL_BikeShopBagFullText
	text_end

BikeShopMiddleAgedWomanText:
	text_asm
	ld hl, BikeShopMiddleAgedWomanText.Text
	call PrintText
	jp TextScriptEnd

BikeShopMiddleAgedWomanText.Text:
	text_far WLA_GLOBAL_BikeShopMiddleAgedWomanText
	text_end

BikeShopYoungsterText:
	text_asm
	CheckEvent EVENT_GOT_BICYCLE
	ld hl, BikeShopYoungsterText.CoolBikeText
	jr nz, BikeShopYoungsterText.gotBike
	ld hl, BikeShopYoungsterText.TheseBikesAreExpensiveText
BikeShopYoungsterText.gotBike
	call PrintText
	jp TextScriptEnd

BikeShopYoungsterText.TheseBikesAreExpensiveText:
	text_far WLA_GLOBAL_BikeShopYoungsterTheseBikesAreExpensiveText
	text_end

BikeShopYoungsterText.CoolBikeText:
	text_far WLA_GLOBAL_BikeShopYoungsterCoolBikeText
	text_end
