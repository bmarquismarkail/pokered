; Museum 2F border, warp, signs, objects, and warp-to record.
Museum2F_Object:
.DB $0A, $01, $07, $07, $04, $34, $02, $02, $0B, $06, $05, $02, $07, $05, $04, $0B
.DB $05, $FE, $02, $01, $25, $09, $04, $FF, $D0, $02, $20, $09, $0B, $FF, $D0, $03
.DB $1D, $09, $0F, $FF, $FF, $04, $0E, $09, $10, $FF, $D0, $05, $20, $C7, $07, $07
Museum2FObjectEnd:
.ASSERT Museum2FObjectEnd - Museum2F_Object == 48
