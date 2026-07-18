; Cinnabar Gym border, warps, trainers, guide, and warp-to records.
CinnabarGym_Object:
	.DB $2E ; border block
	.DB $02 ; warp count
	.DB $11,$10,$01,$FF
	.DB $11,$11,$01,$FF
	.DB $00 ; background-event count
	.DB $09 ; object count
	.DB $0A,$07,$07,$FF,$D0,$41,$EF,$01
	.DB $0C,$06,$15,$FF,$D0,$42,$D0,$09
	.DB $0C,$0C,$15,$FF,$D0,$43,$D3,$04
	.DB $0C,$08,$0F,$FF,$D0,$44,$D0,$0A
	.DB $0C,$0C,$0F,$FF,$D0,$45,$D3,$05
	.DB $0C,$12,$0F,$FF,$D0,$46,$D0,$0B
	.DB $0C,$12,$07,$FF,$D0,$47,$D3,$06
	.DB $0C,$0C,$07,$FF,$D0,$48,$D0,$0C
	.DB $24,$11,$14,$FF,$D0,$09
	.DB $81,$C7,$11,$10
	.DB $81,$C7,$11,$11
CinnabarGymObjectEnd:
.ASSERT CinnabarGymObjectEnd - CinnabarGym_Object == 90
