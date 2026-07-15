VermilionMartCooltrainerMText:
	.DB $17
	.DW $69C1
	.DB $26, $50
VermilionMartCooltrainerFText:
	.DB $17
	.DW $6A67
	.DB $26, $50
VermilionMartTextsEnd:
.ASSERT VermilionMartTextsEnd - VermilionMartCooltrainerMText == 10
