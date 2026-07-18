SilphCo9FRocket1Text:
	.DB $08
	LD HL, SilphCo9TrainerHeader0
	CALL $31CC ; TalkToTrainer
	JP $24D7
SilphCo9FScientistText:
	.DB $08
	LD HL, SilphCo9TrainerHeader1
	CALL $31CC
	JP $24D7
SilphCo9FRocket2Text:
	.DB $08
	LD HL, SilphCo9TrainerHeader2
	CALL $31CC
	JP $24D7
SilphCo9FTrainerHandlersEnd:
.ASSERT SilphCo9FTrainerHandlersEnd - SilphCo9FRocket1Text == 30
