SaffronMart_h:
	.DB $02, $04, $04
	.DW $4000
	.DW SaffronMart_TextPointers
	.DW SaffronMart_Script
	.DB $00
	.DW SaffronMart_Object
SaffronMartHeaderEnd:
.ASSERT SaffronMartHeaderEnd - SaffronMart_h == 12
