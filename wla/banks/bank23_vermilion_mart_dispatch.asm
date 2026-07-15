VermilionMart_Script:
	JP $3C3C
VermilionMartScriptEnd:
.ASSERT VermilionMartScriptEnd - VermilionMart_Script == 3
VermilionMart_TextPointers:
.DW $2461, $49EA, $49EF
VermilionMartTextPointersEnd:
.ASSERT VermilionMartTextPointersEnd - VermilionMart_TextPointers == 6
