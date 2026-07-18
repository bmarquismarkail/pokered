PewterMart_h:
	.DB $02,$04,$04
	.DW PewterMart_Blocks
	.DW PewterMart_TextPointers
	.DW PewterMart_Script
	.DB $00
	.DW PewterMart_Object
PewterMartHeaderEnd:
.ASSERT PewterMartHeaderEnd - PewterMart_h == 12
