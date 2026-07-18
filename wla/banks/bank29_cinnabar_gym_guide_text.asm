CinnabarGymGymGuideText:
	.DB $08 ; text_asm
	LD A, ($D79A)
	BIT 1, A ; EVENT_BEAT_BLAINE
	JR NZ, CinnabarGymGymGuideText.afterBeat
	LD HL, CinnabarGymGymGuideText.ChampInMakingText
	JR CinnabarGymGymGuideText.done
CinnabarGymGymGuideText.afterBeat:
	LD HL, CinnabarGymGymGuideText.BeatBlaineText
CinnabarGymGymGuideText.done:
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd
CinnabarGymGymGuideText.ChampInMakingText:
	.DB $17
	.DW $4D5A
	.DB $28,$50
CinnabarGymGymGuideText.BeatBlaineText:
	.DB $17
	.DW $4DD9
	.DB $28,$50
CinnabarGymGuideTextEnd:
.ASSERT CinnabarGymGuideTextEnd - CinnabarGymGymGuideText == 32
