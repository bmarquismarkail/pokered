; Viridian Gym border, warps, objects, and warp-to records.
ViridianGym_Object:
	.DB $03 ; border block
	.DB $02 ; warp count
	.DB $11,$10,$04,$FF
	.DB $11,$11,$04,$FF
	.DB $00 ; background-event count
	.DB $0B ; object count
	.DB $17,$05,$06,$FF,$D0,$41,$E5,$03
	.DB $07,$0B,$10,$FF,$D0,$42,$E7,$09
	.DB $0E,$0F,$0F,$FF,$D1,$43,$E0,$06
	.DB $21,$0B,$0E,$FF,$D0,$44,$DE,$03
	.DB $0E,$0B,$07,$FF,$D2,$45,$E0,$07
	.DB $07,$09,$11,$FF,$D3,$46,$E7,$0A
	.DB $0E,$05,$0E,$FF,$D0,$47,$E0,$08
	.DB $21,$14,$06,$FF,$D3,$48,$DE,$04
	.DB $07,$09,$0A,$FF,$D0,$49,$E7,$01
	.DB $24,$13,$14,$FF,$D0,$0A
	.DB $3D,$0D,$14,$FF,$FF,$8B,$35
	.DB $81,$C7,$11,$10
	.DB $81,$C7,$11,$11
ViridianGymObjectEnd:
.ASSERT ViridianGymObjectEnd - ViridianGym_Object == 105
