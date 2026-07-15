SaffronMart_TextPointers:
	.DW $24C3 ; SaffronMartClerkText
	.DW SaffronMartSuperNerdText
	.DW SaffronMartCooltrainerFText
SaffronMartTextPointersEnd:
.ASSERT SaffronMartTextPointersEnd - SaffronMart_TextPointers == 6
SaffronMartSuperNerdText:
	.DB $17
	.DW $63E3
	.DB $28, $50
SaffronMartCooltrainerFText:
	.DB $17
	.DW $642A
	.DB $28, $50
SaffronMartTextRecordsEnd:
.ASSERT SaffronMartTextRecordsEnd - SaffronMartSuperNerdText == 10
