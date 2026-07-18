; Cinnabar Lab 1F border, rooms, signs, attendant, and warp-to records.
CinnabarLab_Object:
	.DB $17 ; border block
	.DB $05 ; warp count
	.DB $07,$02,$02,$FF
	.DB $07,$03,$02,$FF
	.DB $04,$08,$00,$A8
	.DB $04,$0C,$00,$A9
	.DB $04,$10,$00,$AA
	.DB $04 ; background-event count
	.DB $02,$03,$02
	.DB $04,$09,$03
	.DB $04,$0D,$04
	.DB $04,$11,$05
	.DB $01 ; object count
	.DB $27,$07,$05,$FF,$FF,$01
	.DB $26,$C7,$07,$02
	.DB $26,$C7,$07,$03
	.DB $1A,$C7,$04,$08
	.DB $1C,$C7,$04,$0C
	.DB $1E,$C7,$04,$10
CinnabarLabObjectEnd:
.ASSERT CinnabarLabObjectEnd - CinnabarLab_Object == 62
