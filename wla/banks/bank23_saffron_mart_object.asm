; Object layout translated from data/maps/objects/SaffronMart.asm.
SaffronMart_Object:
	.DB $00, $02
	.DB $07,$03,$04,$FF
	.DB $07,$04,$04,$FF
	.DB $00, $03
	.DB $26,$09,$04,$FF,$D3,$01
	.DB $0C,$06,$08,$FF,$FF,$02
	.DB $06,$09,$0A,$FE,$00,$03
	.DB $12,$C7,$07,$03
	.DB $13,$C7,$07,$04
SaffronMartObjectEnd:
.ASSERT SaffronMartObjectEnd - SaffronMart_Object == 38
