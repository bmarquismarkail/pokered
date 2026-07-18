; Fuchsia Meeting Room border, warps, workers, and warp-to records.
FuchsiaMeetingRoom_Object:
	.DB $17 ; border block
	.DB $02 ; warp count
	.DB $07,$04,$06,$FF
	.DB $07,$05,$06,$FF
	.DB $00 ; background-event count
	.DB $03 ; object count
	.DB $23,$05,$08,$FF,$D0,$01
	.DB $23,$06,$04,$FF,$D1,$02
	.DB $23,$05,$0E,$FF,$D0,$03
	.DB $1F,$C7,$07,$04
	.DB $1F,$C7,$07,$05
FuchsiaMeetingRoomObjectEnd:
.ASSERT FuchsiaMeetingRoomObjectEnd - FuchsiaMeetingRoom_Object == 38
