CeruleanCave1F_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
CeruleanCave1FScriptEnd:
.ASSERT CeruleanCave1FScriptEnd - CeruleanCave1F_Script == 3

CeruleanCave1F_TextPointers:
	.DW $24F4,$24F4,$24F4 ; PickUpItemText
CeruleanCave1FTextPointersEnd:
.ASSERT CeruleanCave1FTextPointersEnd - CeruleanCave1F_TextPointers == 6
