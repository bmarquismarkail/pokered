SaffronGymChanneler1Text:
	.DB $08
	LD HL, SaffronGymTrainerHeader0
	CALL $31CC
	JP $24D7
SaffronGymYoungster1Text:
	.DB $08
	LD HL, SaffronGymTrainerHeader1
	CALL $31CC
	JP $24D7
SaffronGymChanneler2Text:
	.DB $08
	LD HL, SaffronGymTrainerHeader2
	CALL $31CC
	JP $24D7
SaffronGymYoungster2Text:
	.DB $08
	LD HL, SaffronGymTrainerHeader3
	CALL $31CC
	JP $24D7
SaffronGymChanneler3Text:
	.DB $08
	LD HL, SaffronGymTrainerHeader4
	CALL $31CC
	JP $24D7
SaffronGymYoungster3Text:
	.DB $08
	LD HL, SaffronGymTrainerHeader5
	CALL $31CC
	JP $24D7
SaffronGymYoungster4Text:
	.DB $08
	LD HL, SaffronGymTrainerHeader6
	CALL $31CC
	JP $24D7
SaffronGymTrainerHandlersEnd:
.ASSERT SaffronGymTrainerHandlersEnd - SaffronGymChanneler1Text == 70
