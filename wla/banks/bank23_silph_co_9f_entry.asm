SilphCo9F_h:
	.DB $16, $09, $0D
	.DW SilphCo9F_Blocks
	.DW SilphCo9F_TextPointers
	.DW SilphCo9F_Script
	.DB $00
	.DW SilphCo9F_Object
SilphCo9FHeaderEnd:
.ASSERT SilphCo9FHeaderEnd - SilphCo9F_h == 12
SilphCo9F_Script:
	CALL SilphCo9FGateCallbackScript
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD HL, SilphCo9TrainerHeaders
	LD DE, SilphCo9F_ScriptPointers
	LD A, ($D64A) ; wSilphCo9FCurScript
	CALL $3160 ; ExecuteCurMapScriptInTable
	LD ($D64A), A
	RET
SilphCo9FEntryEnd:
.ASSERT SilphCo9FEntryEnd - SilphCo9F_Script == 22
