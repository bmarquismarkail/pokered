CeruleanPokecenter_Object:
.DB $00, $02
.DB $07, $03, $02, $FF
.DB $07, $04, $02, $FF
.DB $00, $04
.DB $29, $05, $07, $FF, $D0, $01
.DB $0C, $09, $0E, $FE, $00, $02
.DB $10, $07, $08, $FF, $D0, $03
.DB $2A, $06, $0F, $FF, $D0, $04
.DB $1E, $C7, $07, $03
.DB $1F, $C7, $07, $04
CeruleanPokecenterObjectEnd:
.ASSERT CeruleanPokecenterObjectEnd - CeruleanPokecenter_Object == 44
