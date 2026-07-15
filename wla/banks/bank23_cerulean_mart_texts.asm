CeruleanMartCooltrainerMText:
	.DB $17
	.DW $5012
	.DB $26, $50
CeruleanMartCooltrainerFText:
	.DB $17
	.DW $507F
	.DB $26, $50
CeruleanMartTextsEnd:
.ASSERT CeruleanMartTextsEnd - CeruleanMartCooltrainerMText == 10
