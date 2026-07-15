; Object layout translated from data/maps/objects/SilphCo1F.asm.
SilphCo1F_Object:
	.DB $2E, $05
	.DB $11,$0A,$05,$FF
	.DB $11,$0B,$05,$FF
	.DB $00,$1A,$00,$CF
	.DB $00,$14,$00,$EC
	.DB $0A,$10,$06,$D0
	.DB $00, $01
	.DB $2A,$06,$08,$FF,$D0,$01
	.DB $AB,$C7,$11,$0A
	.DB $AB,$C7,$11,$0B
	.DB $0B,$C7,$00,$1A
	.DB $08,$C7,$00,$14
	.DB $6F,$C7,$0A,$10
SilphCo1FObjectEnd:
.ASSERT SilphCo1FObjectEnd - SilphCo1F_Object == 50
