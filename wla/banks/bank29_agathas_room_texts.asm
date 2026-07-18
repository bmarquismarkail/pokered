AgathasRoom_TextPointers:
	.DW AgathasRoomAgathaText,AgathasRoomAgathaDontRunAwayText
AgathasRoomTextPointersEnd:
.ASSERT AgathasRoomTextPointersEnd - AgathasRoom_TextPointers == 4

AgathasRoomTrainerHeaders:
AgathasRoomTrainerHeader0:
	.DB $01,$00
	.DW $D865
	.DW AgathaBeforeBattleText,AgathaAfterBattleText,AgathaEndBattleText,AgathaEndBattleText
	.DB $FF
AgathasRoomTrainerHeadersEnd:
.ASSERT AgathasRoomTrainerHeadersEnd - AgathasRoomTrainerHeaders == 13

AgathasRoomAgathaText:
	.DB $08 ; text_asm
	LD HL, AgathasRoomTrainerHeader0
	CALL $31CC ; TalkToTrainer
	JP $24D7 ; TextScriptEnd
AgathasRoomAgathaTextEnd:
.ASSERT AgathasRoomAgathaTextEnd - AgathasRoomAgathaText == 10

AgathaBeforeBattleText:
	.DB $17
	.DW $686B
	.DB $21,$50
AgathaEndBattleText:
	.DB $17
	.DW $6970
	.DB $21,$50
AgathaAfterBattleText:
	.DB $17
	.DW $6998
	.DB $21,$50
AgathasRoomAgathaDontRunAwayText:
	.DB $17
	.DW $69FD
	.DB $21,$50
AgathasRoomTextRecordsEnd:
.ASSERT AgathasRoomTextRecordsEnd - AgathaBeforeBattleText == 20
