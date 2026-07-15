; Object layout translated from data/maps/objects/SaffronPokecenter.asm.
SaffronPokecenter_Object:
	.DB $00, $02
	.DB $07,$03,$06,$FF
	.DB $07,$04,$06,$FF
	.DB $00, $04
	.DB $29,$05,$07,$FF,$D0,$01
	.DB $0F,$09,$09,$FF,$FF,$02
	.DB $10,$07,$0C,$FF,$D0,$03
	.DB $2A,$06,$0F,$FF,$D0,$04
	.DB $1E,$C7,$07,$03
	.DB $1F,$C7,$07,$04
SaffronPokecenterObjectEnd:
.ASSERT SaffronPokecenterObjectEnd - SaffronPokecenter_Object == 44
