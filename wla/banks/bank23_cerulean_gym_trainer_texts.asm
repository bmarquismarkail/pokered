CeruleanGymCooltrainerFText:
	.DB $08
	LD HL, CeruleanGymTrainerHeader0
	CALL $31CC
	JP $24D7
CeruleanGymBattleText1:
	.DB $17
	.DW $4C05
	.DB $26, $50
CeruleanGymEndBattleText1:
	.DB $17
	.DW $4C38
	.DB $26, $50
CeruleanGymAfterBattleText1:
	.DB $17
	.DW $4C4D
	.DB $26, $50
CeruleanGymSwimmerText:
	.DB $08
	LD HL, CeruleanGymTrainerHeader1
	CALL $31CC
	JP $24D7
CeruleanGymBattleText2:
	.DB $17
	.DW $4C93
	.DB $26, $50
CeruleanGymEndBattleText2:
	.DB $17
	.DW $4CB5
	.DB $26, $50
CeruleanGymAfterBattleText2:
	.DB $17
	.DW $4CC4
	.DB $26, $50
CeruleanGymTrainerTextsEnd:
.ASSERT CeruleanGymTrainerTextsEnd - CeruleanGymCooltrainerFText == 50
