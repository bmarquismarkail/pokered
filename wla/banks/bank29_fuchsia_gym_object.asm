; Fuchsia Gym border, warps, trainers, guide, and warp-to records.
FuchsiaGym_Object:
	.DB $03 ; border block
	.DB $02 ; warp count
	.DB $11,$04,$05,$FF
	.DB $11,$05,$05,$FF
	.DB $00 ; background-event count
	.DB $08 ; object count
	.DB $30,$0E,$08,$FF,$D0,$41,$EE,$01
	.DB $21,$11,$0C,$FF,$D0,$42,$DD,$07
	.DB $21,$0C,$0B,$FF,$D3,$43,$DD,$03
	.DB $21,$10,$05,$FF,$D0,$44,$DD,$08
	.DB $21,$09,$07,$FF,$D1,$45,$DE,$01
	.DB $21,$06,$0C,$FF,$D0,$46,$DE,$02
	.DB $21,$0B,$06,$FF,$D2,$47,$DD,$04
	.DB $24,$13,$0B,$FF,$D0,$08
	.DB $4E,$C7,$11,$04
	.DB $4E,$C7,$11,$05
FuchsiaGymObjectEnd:
.ASSERT FuchsiaGymObjectEnd - FuchsiaGym_Object == 82
