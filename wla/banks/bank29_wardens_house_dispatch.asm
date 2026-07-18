WardensHouse_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
WardensHouseScriptEnd:
.ASSERT WardensHouseScriptEnd - WardensHouse_Script == 3

WardensHouse_TextPointers:
	.DW WardensHouseWardenText
	.DW $24F4 ; PickUpItemText
	.DW $24E5 ; BoulderText
	.DW WardensHouseDisplayText
	.DW WardensHouseDisplayText
WardensHouseTextPointersEnd:
.ASSERT WardensHouseTextPointersEnd - WardensHouse_TextPointers == 10
