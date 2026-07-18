FuchsiaGymTrainerTexts:
FuchsiaGymRocker1Text:
	.DB $08
	LD HL, FuchsiaGymTrainerHeader0
	CALL $31CC ; TalkToTrainer
	JP $24D7 ; TextScriptEnd
FuchsiaGymRocker1BattleText:
	.DB $17
	.DW $4160
	.DB $28,$50
FuchsiaGymRocker1EndBattleText:
	.DB $17
	.DW $41C2
	.DB $28,$50
FuchsiaGymRocker1AfterBattleText:
	.DB $17
	.DW $41D8
	.DB $28,$50

FuchsiaGymRocker2Text:
	.DB $08
	LD HL, FuchsiaGymTrainerHeader1
	CALL $31CC
	JP $24D7
FuchsiaGymRocker2BattleText:
	.DB $17
	.DW $4207
	.DB $28,$50
FuchsiaGymRocker2EndBattleText:
	.DB $17
	.DW $423A
	.DB $28,$50
FuchsiaGymRocker2AfterBattleText:
	.DB $17
	.DW $4248
	.DB $28,$50

FuchsiaGymRocker3Text:
	.DB $08
	LD HL, FuchsiaGymTrainerHeader2
	CALL $31CC
	JP $24D7
FuchsiaGymRocker3BattleText:
	.DB $17
	.DW $427E
	.DB $28,$50
FuchsiaGymRocker3EndBattleText:
	.DB $17
	.DW $42A8
	.DB $28,$50
FuchsiaGymRocker3AfterBattleText:
	.DB $17
	.DW $42BC
	.DB $28,$50

FuchsiaGymRocker4Text:
	.DB $08
	LD HL, FuchsiaGymTrainerHeader3
	CALL $31CC
	JP $24D7
FuchsiaGymRocker4BattleText:
	.DB $17
	.DW $42FE
	.DB $28,$50
FuchsiaGymRocker4EndBattleText:
	.DB $17
	.DW $433A
	.DB $28,$50
FuchsiaGymRocker4AfterBattleText:
	.DB $17
	.DW $434D
	.DB $28,$50

FuchsiaGymRocker5Text:
	.DB $08
	LD HL, FuchsiaGymTrainerHeader4
	CALL $31CC
	JP $24D7
FuchsiaGymRocker5BattleText:
	.DB $17
	.DW $43A1
	.DB $28,$50
FuchsiaGymRocker5EndBattleText:
	.DB $17
	.DW $4402
	.DB $28,$50
FuchsiaGymRocker5AfterBattleText:
	.DB $17
	.DW $4409
	.DB $28,$50

FuchsiaGymRocker6Text:
	.DB $08
	LD HL, FuchsiaGymTrainerHeader5
	CALL $31CC
	JP $24D7
FuchsiaGymRocker6BattleText:
	.DB $17
	.DW $4426
	.DB $28,$50
FuchsiaGymRocker6EndBattleText:
	.DB $17
	.DW $4470
	.DB $28,$50
FuchsiaGymRocker6AfterBattleText:
	.DB $17
	.DW $4483
	.DB $28,$50
FuchsiaGymTrainerTextsEnd:
.ASSERT FuchsiaGymTrainerTextsEnd - FuchsiaGymTrainerTexts == 150
