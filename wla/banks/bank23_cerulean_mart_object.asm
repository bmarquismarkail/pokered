CeruleanMart_Object:
.DB $00, $02
.DB $07, $03, $05, $FF
.DB $07, $04, $05, $FF
.DB $00, $03
.DB $26, $09, $04, $FF, $D3, $01
.DB $07, $08, $07, $FE, $01, $02
.DB $06, $06, $0A, $FE, $02, $03
.DB $12, $C7, $07, $03
.DB $13, $C7, $07, $04
CeruleanMartObjectEnd:
.ASSERT CeruleanMartObjectEnd - CeruleanMart_Object == 38
