CeruleanBadgeHouse_Script:
	LD A, 1 ; 1 << BIT_NO_AUTO_TEXT_BOX
	LD ($CF0C), A ; wAutoTextBoxDrawingControl
	DEC A
	LD ($CC3C), A ; wDoNotWaitForButtonPressAfterDisplayingText
	RET
CeruleanBadgeHouseScriptEnd:
.ASSERT CeruleanBadgeHouseScriptEnd - CeruleanBadgeHouse_Script == 10

CeruleanBadgeHouse_TextPointers:
	.DW CeruleanBadgeHouseMiddleAgedManText
CeruleanBadgeHouseTextPointersEnd:
.ASSERT CeruleanBadgeHouseTextPointersEnd - CeruleanBadgeHouse_TextPointers == 2
