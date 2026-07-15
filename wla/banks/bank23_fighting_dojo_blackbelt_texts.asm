FightingDojoBlackbelt1Text:
	.DB $08
	LD HL, FightingDojoTrainerHeader0
	CALL $31CC
	JP $24D7
FightingDojoBlackbelt1BattleText:
	.DB $17
	.DW $5999
	.DB $28, $50
FightingDojoBlackbelt1EndBattleText:
	.DB $17
	.DW $59B7
	.DB $28, $50
FightingDojoBlackbelt1AfterBattleText:
	.DB $17
	.DW $59C3
	.DB $28, $50
FightingDojoBlackbelt2Text:
	.DB $08
	LD HL, FightingDojoTrainerHeader1
	CALL $31CC
	JP $24D7
FightingDojoBlackbelt2BattleText:
	.DB $17
	.DW $5A05
	.DB $28, $50
FightingDojoBlackbelt2EndBattleText:
	.DB $17
	.DW $5A22
	.DB $28, $50
FightingDojoBlackbelt2AfterBattleText:
	.DB $17
	.DW $5A33
	.DB $28, $50
FightingDojoBlackbelt3Text:
	.DB $08
	LD HL, FightingDojoTrainerHeader2
	CALL $31CC
	JP $24D7
FightingDojoBlackbelt3BattleText:
	.DB $17
	.DW $5A51
	.DB $28, $50
FightingDojoBlackbelt3EndBattleText:
	.DB $17
	.DW $5A8D
	.DB $28, $50
FightingDojoBlackbelt3AfterBattleText:
	.DB $17
	.DW $5AA4
	.DB $28, $50
FightingDojoBlackbelt4Text:
	.DB $08
	LD HL, FightingDojoTrainerHeader3
	CALL $31CC
	JP $24D7
FightingDojoBlackbelt4BattleText:
	.DB $17
	.DW $5AD8
	.DB $28, $50
FightingDojoBlackbelt4EndBattleText:
	.DB $17
	.DW $5B09
	.DB $28, $50
FightingDojoBlackbelt4AfterBattleText:
	.DB $17
	.DW $5B1A
	.DB $28, $50
FightingDojoBlackbeltTextsEnd:
.ASSERT FightingDojoBlackbeltTextsEnd - FightingDojoBlackbelt1Text == 100
