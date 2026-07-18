; Fuchsia Pokécenter border, warps, objects, and warp-to records.
FuchsiaPokecenter_Object:
	.DB $00 ; border block
	.DB $02 ; warp count
	.DB $07,$03,$02,$FF
	.DB $07,$04,$02,$FF
	.DB $00 ; background-event count
	.DB $04 ; object count
	.DB $29,$05,$07,$FF,$D0,$01
	.DB $21,$07,$06,$FF,$FF,$02
	.DB $06,$09,$0A,$FE,$02,$03
	.DB $2A,$06,$0F,$FF,$D0,$04
	.DB $1E,$C7,$07,$03
	.DB $1F,$C7,$07,$04
FuchsiaPokecenterObjectEnd:
.ASSERT FuchsiaPokecenterObjectEnd - FuchsiaPokecenter_Object == 44
