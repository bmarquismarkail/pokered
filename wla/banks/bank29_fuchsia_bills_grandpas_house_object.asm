; Fuchsia Bill's Grandpa's House border, warps, objects, and warp-to records.
FuchsiaBillsGrandpasHouse_Object:
	.DB $0A ; border block
	.DB $02 ; warp count
	.DB $07,$02,$01,$FF
	.DB $07,$03,$01,$FF
	.DB $00 ; background-event count
	.DB $03 ; object count
	.DB $1C,$07,$06,$FF,$D3,$01
	.DB $0B,$06,$0B,$FF,$D1,$02
	.DB $04,$09,$09,$FF,$FF,$03
	.DB $12,$C7,$07,$02
	.DB $12,$C7,$07,$03
FuchsiaBillsGrandpasHouseObjectEnd:
.ASSERT FuchsiaBillsGrandpasHouseObjectEnd - FuchsiaBillsGrandpasHouse_Object == 38
