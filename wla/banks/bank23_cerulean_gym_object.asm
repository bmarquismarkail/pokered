CeruleanGym_Object:
.DB $03, $02
.DB $0D, $04, $03, $FF
.DB $0D, $05, $03, $FF
.DB $00, $04
.DB $1D, $06, $08, $FF, $D0, $41, $EB, $01
.DB $06, $07, $06, $FF, $D3, $42, $CE, $01
.DB $22, $0B, $0C, $FF, $D2, $43, $D7, $01
.DB $24, $0E, $0B, $FF, $D0, $04
.DB $38, $C7, $0D, $04
.DB $38, $C7, $0D, $05
CeruleanGymObjectEnd:
.ASSERT CeruleanGymObjectEnd - CeruleanGym_Object == 50
