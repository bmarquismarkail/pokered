LavenderMart_h:
.DB $02, $04, $04
.DW $4000
.DW $492F
.DW $492C
.DB $00
.DW $495D
LavenderMartHeaderEnd:
.ASSERT LavenderMartHeaderEnd - LavenderMart_h == 12
