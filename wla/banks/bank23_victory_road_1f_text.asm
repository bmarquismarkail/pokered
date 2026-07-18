VictoryRoad1FCooltrainerFText:
	.DB $08
	LD HL, VictoryRoad1TrainerHeader0
	CALL $31CC
	JP $24D7
VictoryRoad1FCooltrainerMText:
	.DB $08
	LD HL, VictoryRoad1TrainerHeader1
	CALL $31CC
	JP $24D7
VictoryRoad1FTrainerHandlersEnd:
.ASSERT VictoryRoad1FTrainerHandlersEnd - VictoryRoad1FCooltrainerFText == 20
VictoryRoad1FCooltrainerFBattleText:
	.DB $17
	.DW $5C79
	.DB $21,$50
VictoryRoad1FCooltrainerFEndBattleText:
	.DB $17
	.DW $5CA2
	.DB $21,$50
VictoryRoad1FCooltrainerFAfterBattleText:
	.DB $17
	.DW $5CAF
	.DB $21,$50
VictoryRoad1FCooltrainerMBattleText:
	.DB $17
	.DW $5CD3
	.DB $21,$50
VictoryRoad1FCooltrainerMEndBattleText:
	.DB $17
	.DW $5D07
	.DB $21,$50
VictoryRoad1FCooltrainerMAfterBattleText:
	.DB $17
	.DW $5D1A
	.DB $21,$50
VictoryRoad1FTrainerRecordsEnd:
.ASSERT VictoryRoad1FTrainerRecordsEnd - VictoryRoad1FCooltrainerFBattleText == 30
