; Cinnabar Lab Trade Room warps, occupants, and warp-to records.
CinnabarLabTradeRoom_Object:
	.DB $17 ; border block
	.DB $02 ; warp count
	.DB $07,$02,$02,$A7
	.DB $07,$03,$02,$A7
	.DB $00 ; background-event count
	.DB $03 ; object count
	.DB $0C,$06,$07,$FF,$D0,$01
	.DB $25,$08,$05,$FF,$FF,$02
	.DB $0F,$09,$09,$FF,$D1,$03
	.DB $12,$C7,$07,$02
	.DB $12,$C7,$07,$03
CinnabarLabTradeRoomObjectEnd:
.ASSERT CinnabarLabTradeRoomObjectEnd - CinnabarLabTradeRoom_Object == 38
