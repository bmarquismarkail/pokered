; Museum 1F border, warps, objects, and warp-to records.
Museum1F_Object:
.DB $0A
.DB $05
.DB $07, $0A, $00, $FF, $07, $0B, $00, $FF
.DB $07, $10, $01, $FF, $07, $11, $01, $FF
.DB $07, $07, $00, $35
.DB $00
.DB $05
.DB $20, $08, $10, $FF, $D2, $01
.DB $0B, $08, $05, $FF, $FF, $02
.DB $20, $06, $13, $FF, $D0, $03
.DB $20, $08, $15, $FF, $FF, $04
.DB $45, $06, $14, $FF, $FF, $05
.DB $2E, $C7, $07, $0A, $2E, $C7, $07, $0B
.DB $31, $C7, $07, $10, $31, $C7, $07, $11
.DB $2C, $C7, $07, $07
Museum1FObjectEnd:
.ASSERT Museum1FObjectEnd - Museum1F_Object == 74
