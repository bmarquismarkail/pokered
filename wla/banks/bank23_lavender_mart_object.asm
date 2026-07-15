LavenderMart_Object:
.DB $00, $02
.DB $07, $03, $03, $FF
.DB $07, $04, $03, $FF
.DB $00, $03
.DB $26, $09, $04, $FF, $D3, $01
.DB $34, $08, $07, $FF, $FF, $02
.DB $07, $06, $0B, $FF, $FF, $03
.DB $12, $C7, $07, $03
.DB $13, $C7, $07, $04
LavenderMartObjectEnd:
.ASSERT LavenderMartObjectEnd - LavenderMart_Object == 38
