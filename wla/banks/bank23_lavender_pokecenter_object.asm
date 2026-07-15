LavenderPokecenter_Object:
.DB $00, $02
.DB $07, $03, $00, $FF
.DB $07, $04, $00, $FF
.DB $00, $04
.DB $29, $05, $07, $FF, $D0, $01
.DB $10, $07, $09, $FF, $FF, $02
.DB $08, $0A, $06, $FE, $01, $03
.DB $2A, $06, $0F, $FF, $D0, $04
.DB $1E, $C7, $07, $03
.DB $1F, $C7, $07, $04
LavenderPokecenterObjectEnd:
.ASSERT LavenderPokecenterObjectEnd - LavenderPokecenter_Object == 44
