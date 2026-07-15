FightingDojo_h:
.DB $05, $06, $05
.DW $4FE3
.DW $4E03
.DW $4D5D
.DB $00
.DW $4F9B
FightingDojoHeaderEnd:
.ASSERT FightingDojoHeaderEnd - FightingDojo_h == 12

FightingDojo_Script:
	CALL $3C3C
	LD HL, $4E13
	LD DE, $4D7B
	LD A, ($D642)
	CALL $3160
	LD ($D642), A
	RET
FightingDojoScriptEnd:
.ASSERT FightingDojoScriptEnd - FightingDojo_Script == 19

FightingDojoResetScripts:
	XOR A
	LD ($CD6B), A
	LD ($D642), A
	LD ($DA39), A
	RET
FightingDojoResetEnd:
.ASSERT FightingDojoResetEnd - FightingDojoResetScripts == 11

FightingDojo_ScriptPointers:
.DW $4D83, $324C, $3275, $4DC6
FightingDojoScriptPointersEnd:
.ASSERT FightingDojoScriptPointersEnd - FightingDojo_ScriptPointers == 8
