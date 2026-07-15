SaffronGymGymGuideText:
	.DB $08
	LD A, ($D7B3)
	BIT 1, A ; EVENT_BEAT_SABRINA
	JR NZ, SaffronGymGymGuideText.afterBeat
	LD HL, SaffronGymGymGuideText.ChampInMakingText
	CALL PrintText
	JR SaffronGymGymGuideText.done
SaffronGymGymGuideText.afterBeat:
	LD HL, SaffronGymGymGuideText.BeatSabrinaText
	CALL PrintText
SaffronGymGymGuideText.done:
	JP $24D7
SaffronGymGymGuideText.ChampInMakingText:
	.DB $17
	.DW $5E48
	.DB $28, $50
SaffronGymGymGuideText.BeatSabrinaText:
	.DB $17
	.DW $5EF0
	.DB $28, $50
SaffronGymGuideTextEnd:
.ASSERT SaffronGymGuideTextEnd - SaffronGymGymGuideText == 35
