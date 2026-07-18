PewterMart_Script:
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD A, 1 ; 1 << BIT_NO_AUTO_TEXT_BOX
	LD ($CF0C), A ; wAutoTextBoxDrawingControl
	RET
PewterMartScriptEnd:
.ASSERT PewterMartScriptEnd - PewterMart_Script == 9

PewterMart_TextPointers:
	.DW $2449 ; PewterMartClerkText
	.DW PewterMartYoungsterText
	.DW PewterMartSuperNerdText
PewterMartTextPointersEnd:
.ASSERT PewterMartTextPointersEnd - PewterMart_TextPointers == 6
