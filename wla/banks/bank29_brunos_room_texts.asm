BrunosRoom_TextPointers:
	.DW BrunosRoomBrunoText,BrunosRoomBrunoDontRunAwayText
BrunosRoomTextPointersEnd:
.ASSERT BrunosRoomTextPointersEnd - BrunosRoom_TextPointers == 4

BrunosRoomTrainerHeaders:
BrunosRoomTrainerHeader0:
	.DB $01,$00
	.DW $D864
	.DW BrunoBeforeBattleText,BrunoAfterBattleText,BrunoEndBattleText,BrunoEndBattleText
	.DB $FF
BrunosRoomTrainerHeadersEnd:
.ASSERT BrunosRoomTrainerHeadersEnd - BrunosRoomTrainerHeaders == 13

BrunosRoomBrunoText:
	.DB $08
	LD HL, BrunosRoomTrainerHeader0
	CALL $31CC
	JP $24D7
BrunosRoomBrunoTextEnd:
.ASSERT BrunosRoomBrunoTextEnd - BrunosRoomBrunoText == 10

BrunoBeforeBattleText:
	.DB $17
	.DW $6749
	.DB $21,$50
BrunoEndBattleText:
	.DB $17
	.DW $6805
	.DB $21,$50
BrunoAfterBattleText:
	.DB $17
	.DW $681D
	.DB $21,$50
BrunosRoomBrunoDontRunAwayText:
	.DB $17
	.DW $684B
	.DB $21,$50
BrunosRoomTextRecordsEnd:
.ASSERT BrunosRoomTextRecordsEnd - BrunoBeforeBattleText == 20
