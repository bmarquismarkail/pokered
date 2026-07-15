CeruleanGymGymGuideText:
	.DB $08
	LD A, ($D75E)
	BIT 7, A ; EVENT_BEAT_MISTY
	JR NZ, CeruleanGymGymGuideText.afterBeat
	LD HL, CeruleanGymGymGuideText.ChampInMakingText
	CALL PrintText
	JR CeruleanGymGymGuideText.done
CeruleanGymGymGuideText.afterBeat:
	LD HL, CeruleanGymGymGuideText.BeatMistyText
	CALL PrintText
CeruleanGymGymGuideText.done:
	JP $24D7
CeruleanGymGymGuideText.ChampInMakingText:
	.DB $17
	.DW $4D0A
	.DB $26, $50
CeruleanGymGymGuideText.BeatMistyText:
	.DB $17
	.DW $4DB0
	.DB $26, $50
CeruleanGymGuideTextEnd:
.ASSERT CeruleanGymGuideTextEnd - CeruleanGymGymGuideText == 35
