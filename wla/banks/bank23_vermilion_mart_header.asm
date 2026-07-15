VermilionMart_h:
.DB $02, $04, $04
.DW $4000
.DW $49E4
.DW $49E1
.DB $00
.DW $49F4
VermilionMartHeaderEnd:
.ASSERT VermilionMartHeaderEnd - VermilionMart_h == 12
