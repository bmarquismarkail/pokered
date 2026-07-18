VictoryRoad1F_h:
	.DB $11, $09, $0A
	.DW VictoryRoad1F_Blocks
	.DW VictoryRoad1F_TextPointers
	.DW VictoryRoad1F_Script
	.DB $00
	.DW VictoryRoad1F_Object
VictoryRoad1FHeaderEnd:
.ASSERT VictoryRoad1FHeaderEnd - VictoryRoad1F_h == 12
VictoryRoad1F_Script:
	LD HL, $D126 ; wCurrentMapScriptFlags
	BIT 5, (HL)
	RES 5, (HL)
	CALL NZ, VictoryRoad1F_Script.next
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD HL, VictoryRoad1TrainerHeaders
	LD DE, VictoryRoad1F_ScriptPointers
	LD A, ($D651) ; wVictoryRoad1FCurScript
	CALL $3160
	LD ($D651), A
	RET
VictoryRoad1F_Script.next:
	LD A, ($D869)
	BIT 7, A ; EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
	RET Z
	LD A, $1D
	LD ($D09F), A
	LD BC, $0604
	LD A, $17 ; ReplaceTileBlock predef
	JP $3E6D
VictoryRoad1FEntryEnd:
.ASSERT VictoryRoad1FEntryEnd - VictoryRoad1F_Script == 48
