CeruleanBadgeHouse_Script:
	ld a, 1 << BIT_NO_AUTO_TEXT_BOX
	ld [wAutoTextBoxDrawingControl], a
	dec a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret

CeruleanBadgeHouse_TextPointers:
	def_text_pointers
	dw_const CeruleanBadgeHouseMiddleAgedManText, TEXT_CERULEANBADGEHOUSE_MIDDLE_AGED_MAN

CeruleanBadgeHouseMiddleAgedManText:
	text_asm
	ld hl, CeruleanBadgeHouseMiddleAgedManText.Text
	call PrintText
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
CeruleanBadgeHouseMiddleAgedManText.loop
	ld hl, CeruleanBadgeHouseMiddleAgedManText.WhichBadgeText
	call PrintText
	ld hl, CeruleanBadgeHouseMiddleAgedManText.BadgeItemList
	call LoadItemList
	ld hl, wItemList
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wPrintItemPrices], a
	ld [wMenuItemToSwap], a
	ld a, SPECIALLISTMENU
	ld [wListMenuID], a
	call DisplayListMenuID
	jr c, CeruleanBadgeHouseMiddleAgedManText.done
	ld hl, CeruleanBadgeHouseBadgeTextPointers
	ld a, [wCurItem]
	sub BOULDERBADGE
	add a
	ld d, $0
	ld e, a
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	jr CeruleanBadgeHouseMiddleAgedManText.loop
CeruleanBadgeHouseMiddleAgedManText.done
	xor a
	ld [wListScrollOffset], a
	ld hl, CeruleanBadgeHouseMiddleAgedManText.VisitAnyTimeText
	call PrintText
	jp TextScriptEnd

CeruleanBadgeHouseMiddleAgedManText.BadgeItemList:
	.DB NUM_BADGES ; #
CeruleanBadgeHouseMiddleAgedManText._table_width_u613:
	table_width 1
	.DB BOULDERBADGE
	.DB CASCADEBADGE
	.DB THUNDERBADGE
	.DB RAINBOWBADGE
	.DB SOULBADGE
	.DB MARSHBADGE
	.DB VOLCANOBADGE
	.DB EARTHBADGE
	assert_table_length NUM_BADGES
	.DB -1 ; end

CeruleanBadgeHouseMiddleAgedManText.Text:
	text_far WLA_GLOBAL_CeruleanBadgeHouseMiddleAgedManText
	text_end

CeruleanBadgeHouseMiddleAgedManText.WhichBadgeText:
	text_far WLA_GLOBAL_CeruleanBadgeHouseMiddleAgedManWhichBadgeText
	text_end

CeruleanBadgeHouseMiddleAgedManText.VisitAnyTimeText:
	text_far WLA_GLOBAL_CeruleanBadgeHouseMiddleAgedManVisitAnyTimeText
	text_end

CeruleanBadgeHouseBadgeTextPointers:
	table_width 2
	.DW CeruleanBadgeHouseBoulderBadgeText
	.DW CeruleanBadgeHouseCascadeBadgeText
	.DW CeruleanBadgeHouseThunderBadgeText
	.DW CeruleanBadgeHouseRainbowBadgeText
	.DW CeruleanBadgeHouseSoulBadgeText
	.DW CeruleanBadgeHouseMarshBadgeText
	.DW CeruleanBadgeHouseVolcanoBadgeText
	.DW CeruleanBadgeHouseEarthBadgeText
	assert_table_length NUM_BADGES

CeruleanBadgeHouseBoulderBadgeText:
	text_far WLA_GLOBAL_CeruleanBadgeHouseBoulderBadgeText
	text_end

CeruleanBadgeHouseCascadeBadgeText:
	text_far WLA_GLOBAL_CeruleanBadgeHouseCascadeBadgeText
	text_end

CeruleanBadgeHouseThunderBadgeText:
	text_far WLA_GLOBAL_CeruleanBadgeHouseThunderBadgeText
	text_end

CeruleanBadgeHouseRainbowBadgeText:
	text_far WLA_GLOBAL_CeruleanBadgeHouseRainbowBadgeText
	text_end

CeruleanBadgeHouseSoulBadgeText:
	text_far WLA_GLOBAL_CeruleanBadgeHouseSoulBadgeText
	text_end

CeruleanBadgeHouseMarshBadgeText:
	text_far WLA_GLOBAL_CeruleanBadgeHouseMarshBadgeText
	text_end

CeruleanBadgeHouseVolcanoBadgeText:
	text_far WLA_GLOBAL_CeruleanBadgeHouseVolcanoBadgeText
	text_end

CeruleanBadgeHouseEarthBadgeText:
	text_far WLA_GLOBAL_CeruleanBadgeHouseEarthBadgeText
	text_end
