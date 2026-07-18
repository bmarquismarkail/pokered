FuchsiaGymGymGuideText:
	.DB $08 ; text_asm
	LD A, ($D792)
	BIT 1, A ; EVENT_BEAT_KOGA
	LD HL, FuchsiaGymGymGuideText.BeatKogaText
	JR NZ, FuchsiaGymGymGuideText.afterBeat
	LD HL, FuchsiaGymGymGuideText.ChampInMakingText
FuchsiaGymGymGuideText.afterBeat:
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd
FuchsiaGymGymGuideText.ChampInMakingText:
	.DB $17
	.DW $44D2
	.DB $28,$50
FuchsiaGymGymGuideText.BeatKogaText:
	.DB $17
	.DW $4574
	.DB $28,$50
FuchsiaGymGuideTextEnd:
.ASSERT FuchsiaGymGuideTextEnd - FuchsiaGymGymGuideText == 30
