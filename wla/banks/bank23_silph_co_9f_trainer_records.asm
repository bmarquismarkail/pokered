SilphCo9FRocket1BattleText:
	.DB $17
	.DW $4C5C
	.DB $21, $50
SilphCo9FRocket1EndBattleText:
	.DB $17
	.DW $4C7F
	.DB $21, $50
SilphCo9FRocket1AfterBattleText:
	.DB $17
	.DW $4C88
	.DB $21, $50
SilphCo9FScientistBattleText:
	.DB $17
	.DW $4CB6
	.DB $21, $50
SilphCo9FScientistEndBattleText:
	.DB $17
	.DW $4CE4
	.DB $21, $50
SilphCo9FScientistAfterBattleText:
	.DB $17
	.DW $4CF6
	.DB $21, $50
SilphCo9FRocket2BattleText:
	.DB $17
	.DW $4D33
	.DB $21, $50
SilphCo9FRocket2EndBattleText:
	.DB $17
	.DW $4D57
	.DB $21, $50
SilphCo9FRocket2AfterBattleText:
	.DB $17
	.DW $4D70
	.DB $21, $50
SilphCo9FTrainerRecordsEnd:
.ASSERT SilphCo9FTrainerRecordsEnd - SilphCo9FRocket1BattleText == 45
