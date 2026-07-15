VermilionMart_Object:
.DB $00, $02
.DB $07, $03, $02, $FF
.DB $07, $04, $02, $FF
.DB $00, $03
.DB $26, $09, $04, $FF, $D3, $01
.DB $07, $0A, $09, $FF, $FF, $02
.DB $06, $07, $07, $FE, $02, $03
.DB $12, $C7, $07, $03
.DB $13, $C7, $07, $04
VermilionMartObjectEnd:
.ASSERT VermilionMartObjectEnd - VermilionMart_Object == 38
