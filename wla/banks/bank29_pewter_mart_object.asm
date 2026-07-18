; Pewter Mart border, warps, objects, and warp-to records.
PewterMart_Object:
	.DB $00 ; border block
	.DB $02 ; warp count
	.DB $07,$03,$04,$FF
	.DB $07,$04,$04,$FF
	.DB $00 ; background-event count
	.DB $03 ; object count
	.DB $26,$09,$04,$FF,$D3,$01
	.DB $04,$07,$07,$FE,$01,$02
	.DB $0C,$09,$09,$FF,$FF,$03
	.DB $12,$C7,$07,$03
	.DB $13,$C7,$07,$04
PewterMartObjectEnd:
.ASSERT PewterMartObjectEnd - PewterMart_Object == 38
