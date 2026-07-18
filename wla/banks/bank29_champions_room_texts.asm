ChampionsRoom_TextPointers:
	.DW ChampionsRoomRivalText,ChampionsRoomOakText,ChampionsRoomOakCongratulatesPlayerText
	.DW ChampionsRoomOakDisappointedWithRivalText,ChampionsRoomOakComeWithMeText
ChampionsRoomTextPointersEnd:
.ASSERT ChampionsRoomTextPointersEnd - ChampionsRoom_TextPointers == 10

ChampionsRoomRivalText:
	.DB $08 ; text_asm
	LD A, ($D867)
	BIT 1, A ; EVENT_BEAT_CHAMPION_RIVAL
	LD HL, ChampionsRoomRivalText.IntroText
	JR Z, ChampionsRoomRivalText.printText
	LD HL, ChampionsRoomRivalAfterBattleText
ChampionsRoomRivalText.printText:
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd
ChampionsRoomRivalText.IntroText:
	.DB $17
	.DW $60E1
	.DB $21,$50
ChampionsRoomRivalTextEnd:
.ASSERT ChampionsRoomRivalTextEnd - ChampionsRoomRivalText == 25

RivalDefeatedText:
	.DB $17
	.DW $623B
	.DB $21,$50
RivalVictoryText:
	.DB $17
	.DW $62B4
	.DB $21,$50
ChampionsRoomRivalAfterBattleText:
	.DB $17
	.DW $632F
	.DB $21,$50
ChampionsRoomOakText:
	.DB $17
	.DW $63C1
	.DB $21,$50
ChampionsRoomBattleTextRecordsEnd:
.ASSERT ChampionsRoomBattleTextRecordsEnd - RivalDefeatedText == 20

ChampionsRoomOakCongratulatesPlayerText:
	.DB $08 ; text_asm
	LD A, ($D717) ; wPlayerStarter
	LD ($D11E), A ; wNamedObjectIndex
	CALL $2F9E ; GetMonName
	LD HL, ChampionsRoomOakCongratulatesPlayerText.Text
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd
ChampionsRoomOakCongratulatesPlayerText.Text:
	.DB $17
	.DW $63CA
	.DB $21,$50
ChampionsRoomOakCongratulatesTextEnd:
.ASSERT ChampionsRoomOakCongratulatesTextEnd - ChampionsRoomOakCongratulatesPlayerText == 24

ChampionsRoomOakDisappointedWithRivalText:
	.DB $17
	.DW $6463
	.DB $21,$50
ChampionsRoomOakComeWithMeText:
	.DB $17
	.DW $6567
	.DB $21,$50
ChampionsRoomOakTextsEnd:
.ASSERT ChampionsRoomOakTextsEnd - ChampionsRoomOakDisappointedWithRivalText == 10
