; Cinnabar Pokecenter warps, occupants, and warp-to records.
CinnabarPokecenter_Object:
	.DB $00 ; border block
	.DB $02 ; warp count
	.DB $07,$03,$03,$FF
	.DB $07,$04,$03,$FF
	.DB $00 ; background-event count
	.DB $04 ; object count
	.DB $29,$05,$07,$FF,$D0,$01
	.DB $06,$08,$0D,$FE,$00,$02
	.DB $10,$0A,$06,$FF,$FF,$03
	.DB $2A,$06,$0F,$FF,$D0,$04
	.DB $1E,$C7,$07,$03
	.DB $1F,$C7,$07,$04
CinnabarPokecenterObjectEnd:
.ASSERT CinnabarPokecenterObjectEnd - CinnabarPokecenter_Object == 44
