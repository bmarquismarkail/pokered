LoreleisRoom_h:
	.DB $07,$06,$05
	.DW LoreleisRoom_Blocks
	.DW LoreleisRoom_TextPointers
	.DW LoreleisRoom_Script
	.DB $00
	.DW LoreleisRoom_Object
LoreleisRoomHeaderEnd:
.ASSERT LoreleisRoomHeaderEnd - LoreleisRoom_h == 12

LoreleisRoom_Script:
	CALL LoreleiShowOrHideExitBlock
	CALL $3C3C ; EnableAutoTextBoxDrawing
	LD HL, LoreleisRoomTrainerHeaders
	LD DE, LoreleisRoom_ScriptPointers
	LD A, ($D64D) ; wLoreleisRoomCurScript
	CALL $3160 ; ExecuteCurMapScriptInTable
	LD ($D64D), A
	RET
LoreleisRoomScriptEnd:
.ASSERT LoreleisRoomScriptEnd - LoreleisRoom_Script == 22

LoreleiShowOrHideExitBlock:
	LD HL, $D126 ; wCurrentMapScriptFlags
	BIT 5, (HL) ; BIT_CUR_MAP_LOADED_1
	RES 5, (HL)
	RET Z
	LD HL, $D734 ; wElite4Flags
	SET 1, (HL) ; BIT_STARTED_ELITE_4
	LD A, ($D863)
	BIT 1, A ; EVENT_BEAT_LORELEIS_ROOM_TRAINER_0
	JR Z, LoreleiShowOrHideExitBlock.blockExit
	LD A, 5
	JR LoreleiShowOrHideExitBlock.setExitBlock
LoreleiShowOrHideExitBlock.blockExit:
	LD A, $24
LoreleiShowOrHideExitBlock.setExitBlock:
	LD ($D09F), A ; wNewTileBlockID
	LD BC, $0002
	LD A, $17 ; ReplaceTileBlock predef
	JP $3E6D ; Predef
LoreleiShowOrHideExitBlockEnd:
.ASSERT LoreleiShowOrHideExitBlockEnd - LoreleiShowOrHideExitBlock == 37

ResetLoreleiScript:
	XOR A
	LD ($D64D), A
	RET
ResetLoreleiScriptEnd:
.ASSERT ResetLoreleiScriptEnd - ResetLoreleiScript == 5

LoreleisRoom_ScriptPointers:
	.DW LoreleisRoomDefaultScript,$324C,LoreleisRoomLoreleiEndBattleScript
	.DW LoreleisRoomPlayerIsMovingScript,LoreleisRoomNoopScript
LoreleisRoomScriptPointersEnd:
.ASSERT LoreleisRoomScriptPointersEnd - LoreleisRoom_ScriptPointers == 10

LoreleisRoomNoopScript:
	RET
LoreleisRoomNoopEnd:
.ASSERT LoreleisRoomNoopEnd - LoreleisRoomNoopScript == 1
