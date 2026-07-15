CeruleanMart_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
CeruleanMartScriptEnd:
.ASSERT CeruleanMartScriptEnd - CeruleanMart_Script == 3

CeruleanMart_TextPointers:
.DW $2453 ; CeruleanMartClerkText
.DW $489E ; CeruleanMartCooltrainerMText
.DW $48A3 ; CeruleanMartCooltrainerFText
CeruleanMartTextPointersEnd:
.ASSERT CeruleanMartTextPointersEnd - CeruleanMart_TextPointers == 6
