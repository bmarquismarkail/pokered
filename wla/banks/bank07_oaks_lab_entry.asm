; Native WLA-DX form of the Oak's Lab header and script dispatcher.
OaksLab_h:
	.DB $05,$06,$05
	.DW OaksLab_Blocks
	.DW $5082 ; OaksLab_TextPointers
	.DW $4B0E ; OaksLab_Script
	.DB $00
	.DW $540A ; OaksLab_Object
OaksLabHeaderEnd:
.ASSERT OaksLabHeaderEnd - OaksLab_h == 12

OaksLab_Script:
	LD A, ($D74B)
	BIT 6, A ; EVENT_PALLET_AFTER_GETTING_POKEBALLS_2
	CALL NZ, $5076 ; OaksLabLoadTextPointers2Script
	LD A, 1 ; BIT_NO_AUTO_TEXT_BOX
	LD ($CF0C), A ; wAutoTextBoxDrawingControl
	XOR A
	LD ($CC3C), A ; wDoNotWaitForButtonPressAfterDisplayingText
	LD HL, OaksLab_ScriptPointers
	LD A, ($D5F0) ; wOaksLabCurScript
	JP $3D97 ; CallFunctionInTable
OaksLabScriptEnd:
.ASSERT OaksLabScriptEnd - OaksLab_Script == 26

OaksLab_ScriptPointers:
	.DW $4B4E,$4B6E,$4B82,$4BA2,$4BD2,$4BFD,$4C36,$4C72,$4C80,$4D00
	.DW $4D6D,$4DB9,$4E03,$4E32,$4E6D,$4EB0,$4F12,$4FD4,$5009
OaksLabScriptPointersEnd:
.ASSERT OaksLabScriptPointersEnd - OaksLab_ScriptPointers == 38
