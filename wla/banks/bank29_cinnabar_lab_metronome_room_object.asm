; Cinnabar Lab Metronome Room events and warp-to records.
CinnabarLabMetronomeRoom_Object:
	.DB $17 ; border block
	.DB $02 ; warp count
	.DB $07,$02,$03,$A7
	.DB $07,$03,$03,$A7
	.DB $03 ; background-event count
	.DB $04,$00,$03
	.DB $04,$01,$04
	.DB $01,$02,$05
	.DB $02 ; object count
	.DB $20,$06,$0B,$FF,$D0,$01
	.DB $20,$07,$06,$FE,$02,$02
	.DB $12,$C7,$07,$02
	.DB $12,$C7,$07,$03
CinnabarLabMetronomeRoomObjectEnd:
.ASSERT CinnabarLabMetronomeRoomObjectEnd - CinnabarLabMetronomeRoom_Object == 41
