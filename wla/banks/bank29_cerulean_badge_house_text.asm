CeruleanBadgeHouseMiddleAgedManText:
	.DB $08 ; text_asm
	LD HL, CeruleanBadgeHouseMiddleAgedManText.Text
	CALL $3C49 ; PrintText
	XOR A
	LD ($CC26), A ; wCurrentMenuItem
	LD ($CC36), A ; wListScrollOffset
CeruleanBadgeHouseMiddleAgedManText.loop:
	LD HL, CeruleanBadgeHouseMiddleAgedManText.WhichBadgeText
	CALL $3C49 ; PrintText
	LD HL, CeruleanBadgeHouseMiddleAgedManText.BadgeItemList
	CALL $2A5A ; LoadItemList
	LD HL, $CF7B ; wItemList
	LD A, L
	LD ($CF8B), A ; wListPointer
	LD A, H
	LD ($CF8C), A
	XOR A
	LD ($CF93), A ; wPrintItemPrices
	LD ($CC35), A ; wMenuItemToSwap
	LD A, 4 ; SPECIALLISTMENU
	LD ($CF94), A ; wListMenuID
	CALL $2BE6 ; DisplayListMenuID
	JR C, CeruleanBadgeHouseMiddleAgedManText.done
	LD HL, CeruleanBadgeHouseBadgeTextPointers
	LD A, ($CF91) ; wCurItem
	SUB $15 ; BOULDERBADGE
	ADD A, A
	LD D, 0
	LD E, A
	ADD HL, DE
	LD A, (HL+)
	LD H, (HL)
	LD L, A
	CALL $3C49 ; PrintText
	JR CeruleanBadgeHouseMiddleAgedManText.loop
CeruleanBadgeHouseMiddleAgedManText.done:
	XOR A
	LD ($CC36), A ; wListScrollOffset
	LD HL, CeruleanBadgeHouseMiddleAgedManText.VisitAnyTimeText
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd

CeruleanBadgeHouseMiddleAgedManText.BadgeItemList:
	.DB $08,$15,$16,$17,$18,$19,$1A,$1B,$1C,$FF
CeruleanBadgeHouseMiddleAgedManText.Text:
	.DB $17
	.DW $50C9
	.DB $26,$50
CeruleanBadgeHouseMiddleAgedManText.WhichBadgeText:
	.DB $17
	.DW $513A
	.DB $26,$50
CeruleanBadgeHouseMiddleAgedManText.VisitAnyTimeText:
	.DB $17
	.DW $5170
	.DB $26,$50

CeruleanBadgeHouseBadgeTextPointers:
	.DW CeruleanBadgeHouseBoulderBadgeText
	.DW CeruleanBadgeHouseCascadeBadgeText
	.DW CeruleanBadgeHouseThunderBadgeText
	.DW CeruleanBadgeHouseRainbowBadgeText
	.DW CeruleanBadgeHouseSoulBadgeText
	.DW CeruleanBadgeHouseMarshBadgeText
	.DW CeruleanBadgeHouseVolcanoBadgeText
	.DW CeruleanBadgeHouseEarthBadgeText
CeruleanBadgeHouseBoulderBadgeText:
	.DB $17
	.DW $5192
	.DB $26,$50
CeruleanBadgeHouseCascadeBadgeText:
	.DB $17
	.DW $51F2
	.DB $26,$50
CeruleanBadgeHouseThunderBadgeText:
	.DB $17
	.DW $525D
	.DB $26,$50
CeruleanBadgeHouseRainbowBadgeText:
	.DB $17
	.DW $52B8
	.DB $26,$50
CeruleanBadgeHouseSoulBadgeText:
	.DB $17
	.DW $532A
	.DB $26,$50
CeruleanBadgeHouseMarshBadgeText:
	.DB $17
	.DW $5388
	.DB $26,$50
CeruleanBadgeHouseVolcanoBadgeText:
	.DB $17
	.DW $53C7
	.DB $26,$50
CeruleanBadgeHouseEarthBadgeText:
	.DB $17
	.DW $53F5
	.DB $26,$50
CeruleanBadgeHouseTextEnd:
.ASSERT CeruleanBadgeHouseTextEnd - CeruleanBadgeHouseMiddleAgedManText == 169
