LoreleisRoom_TextPointers:
	.DW LoreleisRoomLoreleiText,LoreleisRoomLoreleiDontRunAwayText
LoreleisRoomTextPointersEnd:
.ASSERT LoreleisRoomTextPointersEnd - LoreleisRoom_TextPointers == 4

LoreleisRoomTrainerHeaders:
LoreleisRoomTrainerHeader0:
	.DB $01,$00
	.DW $D863
	.DW LoreleisRoomLoreleiBeforeBattleText,LoreleisRoomLoreleiAfterBattleText
	.DW LoreleisRoomLoreleiEndBattleText,LoreleisRoomLoreleiEndBattleText
	.DB $FF
LoreleisRoomTrainerHeadersEnd:
.ASSERT LoreleisRoomTrainerHeadersEnd - LoreleisRoomTrainerHeaders == 13

LoreleisRoomLoreleiText:
	.DB $08 ; text_asm
	LD HL, LoreleisRoomTrainerHeader0
	CALL $31CC ; TalkToTrainer
	JP $24D7 ; TextScriptEnd
LoreleisRoomLoreleiTextEnd:
.ASSERT LoreleisRoomLoreleiTextEnd - LoreleisRoomLoreleiText == 10

LoreleisRoomLoreleiBeforeBattleText:
	.DB $17
	.DW $65EF
	.DB $21,$50
LoreleisRoomLoreleiEndBattleText:
	.DB $17
	.DW $66C4
	.DB $21,$50
LoreleisRoomLoreleiAfterBattleText:
	.DB $17
	.DW $66D3
	.DB $21,$50
LoreleisRoomLoreleiDontRunAwayText:
	.DB $17
	.DW $6729
	.DB $21,$50
LoreleisRoomTextRecordsEnd:
.ASSERT LoreleisRoomTextRecordsEnd - LoreleisRoomLoreleiBeforeBattleText == 20
