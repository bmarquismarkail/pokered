VermilionGymGentlemanText:
	.DB $08
	LD HL, VermilionGymTrainerHeader0
	CALL $31CC
	JP $24D7
VermilionGymGentlemanBattleText:
	.DB $17
	.DW $4194
	.DB $27, $50
VermilionGymGentlemanEndBattleText:
	.DB $17
	.DW $41C8
	.DB $27, $50
VermilionGymGentlemanAfterBattleText:
	.DB $17
	.DW $41E0
	.DB $27, $50

VermilionGymSuperNerdText:
	.DB $08
	LD HL, VermilionGymTrainerHeader1
	CALL $31CC
	JP $24D7
VermilionGymSuperNerdBattleText:
	.DB $17
	.DW $4213
	.DB $27, $50
VermilionGymSuperNerdEndBattleText:
	.DB $17
	.DW $4244
	.DB $27, $50
VermilionGymSuperNerdAfterBattleText:
	.DB $17
	.DW $424C
	.DB $27, $50

VermilionGymSailorText:
	.DB $08
	LD HL, VermilionGymTrainerHeader2
	CALL $31CC
	JP $24D7
VermilionGymSailorBattleText:
	.DB $17
	.DW $4290
	.DB $27, $50
VermilionGymSailorEndBattleText:
	.DB $17
	.DW $42AC
	.DB $27, $50
VermilionGymSailorAfterBattleText:
	.DB $17
	.DW $42C0
	.DB $27, $50
VermilionGymTrainerTextsEnd:
.ASSERT VermilionGymTrainerTextsEnd - VermilionGymGentlemanText == 75
