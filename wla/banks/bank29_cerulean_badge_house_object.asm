; Cerulean Badge House border, warps, object, and warp-to records.
CeruleanBadgeHouse_Object:
	.DB $0C ; border block
	.DB $03 ; warp count
	.DB $00,$02,$09,$FF
	.DB $07,$02,$08,$FF
	.DB $07,$03,$08,$FF
	.DB $00 ; background-event count
	.DB $01 ; object count
	.DB $0A,$07,$09,$FF,$D3,$01
	.DB $F4,$C6,$00,$02
	.DB $12,$C7,$07,$02
	.DB $12,$C7,$07,$03
CeruleanBadgeHouseObjectEnd:
.ASSERT CeruleanBadgeHouseObjectEnd - CeruleanBadgeHouse_Object == 34
