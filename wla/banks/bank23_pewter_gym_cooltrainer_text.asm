; Pewter Gym junior trainer handler and far-text records.
PewterGymCooltrainerMText:
	.DB $08 ; text_asm
	LD HL, PewterGymTrainerHeader0
	CALL $31CC ; TalkToTrainer
	JP $24D7 ; TextScriptEnd
PewterGymCooltrainerMBattleText:
	.DB $17
	.DW $42AE ; _PewterGymCooltrainerMBattleText
	.DB $26, $50
PewterGymCooltrainerMEndBattleText:
	.DB $17
	.DW $42F1 ; _PewterGymCooltrainerMEndBattleText
	.DB $26, $50
PewterGymCooltrainerMAfterBattleText:
	.DB $17
	.DW $4325 ; _PewterGymCooltrainerMAfterBattleText
	.DB $26, $50
PewterGymCooltrainerTextEnd:
.ASSERT PewterGymCooltrainerTextEnd - PewterGymCooltrainerMText == 25
