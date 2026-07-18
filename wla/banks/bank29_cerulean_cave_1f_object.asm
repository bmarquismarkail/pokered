; Cerulean Cave 1F border, warps, items, and warp-to records.
CeruleanCave1F_Object:
	.DB $7D ; border block
	.DB $09 ; warp count
	.DB $11,$18,$06,$FF
	.DB $11,$19,$06,$FF
	.DB $01,$1B,$00,$E2
	.DB $07,$17,$01,$E2
	.DB $09,$12,$02,$E2
	.DB $01,$07,$03,$E2
	.DB $03,$01,$04,$E2
	.DB $0B,$03,$05,$E2
	.DB $06,$00,$00,$E3
	.DB $00 ; background-event count
	.DB $03 ; object count
	.DB $3D,$11,$0B,$FF,$FF,$81,$10
	.DB $3D,$07,$17,$FF,$FF,$82,$53
	.DB $3D,$04,$09,$FF,$FF,$83,$31
	.DB $B2,$C7,$11,$18
	.DB $B2,$C7,$11,$19
	.DB $0B,$C7,$01,$1B
	.DB $48,$C7,$07,$17
	.DB $5B,$C7,$09,$12
	.DB $01,$C7,$01,$07
	.DB $13,$C7,$03,$01
	.DB $68,$C7,$0B,$03
	.DB $3D,$C7,$06,$00
CeruleanCave1FObjectEnd:
.ASSERT CeruleanCave1FObjectEnd - CeruleanCave1F_Object == 97
