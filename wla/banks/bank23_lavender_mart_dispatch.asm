LavenderMart_Script:
	JP $3C3C
LavenderMartScriptEnd:
.ASSERT LavenderMartScriptEnd - LavenderMart_Script == 3

LavenderMart_TextPointers:
.DW $246A, $4935, $493A
LavenderMartTextPointersEnd:
.ASSERT LavenderMartTextPointersEnd - LavenderMart_TextPointers == 6

LavenderMartBaldingGuyText:
	.DB $17
	.DW $6104
	.DB $26, $50
LavenderMartBaldingGuyTextEnd:
.ASSERT LavenderMartBaldingGuyTextEnd - LavenderMartBaldingGuyText == 5
