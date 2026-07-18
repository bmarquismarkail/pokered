ViridianGymTrainerTexts:
ViridianGymCooltrainerM1Text:
	.DB $08
	LD HL, ViridianGymTrainerHeader0
	CALL $31CC
	JP $24D7
ViridianGymCooltrainerM1BattleText:
	.DB $17
	.DW $6125
	.DB $25,$50
ViridianGymCooltrainerM1EndBattleText:
	.DB $17
	.DW $6154
	.DB $25,$50
ViridianGymCooltrainerM1AfterBattleText:
	.DB $17
	.DW $6167
	.DB $25,$50

ViridianGymHiker1Text:
	.DB $08
	LD HL, ViridianGymTrainerHeader1
	CALL $31CC
	JP $24D7
ViridianGymHiker1BattleText:
	.DB $17
	.DW $6197
	.DB $25,$50
ViridianGymHiker1EndBattleText:
	.DB $17
	.DW $61C0
	.DB $25,$50
ViridianGymHiker1AfterBattleText:
	.DB $17
	.DW $61C8
	.DB $25,$50

ViridianGymRocker1Text:
	.DB $08
	LD HL, ViridianGymTrainerHeader2
	CALL $31CC
	JP $24D7
ViridianGymRocker1BattleText:
	.DB $17
	.DW $61DE
	.DB $25,$50
ViridianGymRocker1EndBattleText:
	.DB $17
	.DW $620D
	.DB $25,$50
ViridianGymRocker1AfterBattleText:
	.DB $17
	.DW $622A
	.DB $25,$50

ViridianGymHiker2Text:
	.DB $08
	LD HL, ViridianGymTrainerHeader3
	CALL $31CC
	JP $24D7
ViridianGymHiker2BattleText:
	.DB $17
	.DW $6257
	.DB $25,$50
ViridianGymHiker2EndBattleText:
	.DB $17
	.DW $6285
	.DB $25,$50
ViridianGymHiker2AfterBattleText:
	.DB $17
	.DW $628D
	.DB $25,$50

ViridianGymCooltrainerM2Text:
	.DB $08
	LD HL, ViridianGymTrainerHeader4
	CALL $31CC
	JP $24D7
ViridianGymCooltrainerM2BattleText:
	.DB $17
	.DW $62B8
	.DB $25,$50
ViridianGymCooltrainerM2EndBattleText:
	.DB $17
	.DW $62DC
	.DB $25,$50
ViridianGymCooltrainerM2AfterBattleText:
	.DB $17
	.DW $62ED
	.DB $25,$50

ViridianGymHiker3Text:
	.DB $08
	LD HL, ViridianGymTrainerHeader5
	CALL $31CC
	JP $24D7
ViridianGymHiker3BattleText:
	.DB $17
	.DW $6308
	.DB $25,$50
ViridianGymHiker3EndBattleText:
	.DB $17
	.DW $6336
	.DB $25,$50
ViridianGymHiker3AfterBattleText:
	.DB $17
	.DW $633D
	.DB $25,$50

ViridianGymRocker2Text:
	.DB $08
	LD HL, ViridianGymTrainerHeader6
	CALL $31CC
	JP $24D7
ViridianGymRocker2BattleText:
	.DB $17
	.DW $6360
	.DB $25,$50
ViridianGymRocker2EndBattleText:
	.DB $17
	.DW $638F
	.DB $25,$50
ViridianGymRocker2AfterBattleText:
	.DB $17
	.DW $63A1
	.DB $25,$50

ViridianGymCooltrainerM3Text:
	.DB $08
	LD HL, ViridianGymTrainerHeader7
	CALL $31CC
	JP $24D7
ViridianGymCooltrainerM3BattleText:
	.DB $17
	.DW $63BD
	.DB $25,$50
ViridianGymCooltrainerM3EndBattleText:
	.DB $17
	.DW $6403
	.DB $25,$50
ViridianGymCooltrainerM3AfterBattleText:
	.DB $17
	.DW $6412
	.DB $25,$50
ViridianGymTrainerTextsEnd:
.ASSERT ViridianGymTrainerTextsEnd - ViridianGymTrainerTexts == 200
