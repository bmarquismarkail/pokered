; Museum 1F map-script dispatcher.
Museum1F_Script:
	LD A, $01 ; BIT_NO_AUTO_TEXT_BOX
	LD ($CF0C), A ; wAutoTextBoxDrawingControl
	XOR A
	LD ($CC3C), A ; wDoNotWaitForButtonPressAfterDisplayingText
	LD HL, $4109 ; Museum1F_ScriptPointers
	LD A, ($D619) ; wMuseum1FCurScript
	JP $3D97 ; CallFunctionInTable
Museum1FScriptEnd:
.ASSERT Museum1FScriptEnd - Museum1F_Script == 18
