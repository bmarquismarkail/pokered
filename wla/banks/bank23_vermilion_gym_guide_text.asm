VermilionGymGymGuideText:
	.DB $08
	LD A, ($D72A)
	BIT 2, A
	JR NZ, VermilionGymGymGuideText.got_thunderbadge
	LD HL, VermilionGymGymGuideText.ChampInMakingText
	CALL PrintText
	JR VermilionGymGymGuideText.text_script_end
VermilionGymGymGuideText.got_thunderbadge:
	LD HL, VermilionGymGymGuideText.BeatLTSurgeText
	CALL PrintText
VermilionGymGymGuideText.text_script_end:
	JP $24D7
VermilionGymGymGuideText.ChampInMakingText:
	.DB $17
	.DW $432B
	.DB $27, $50
VermilionGymGymGuideText.BeatLTSurgeText:
	.DB $17
	.DW $4429
	.DB $27, $50
VermilionGymGuideTextEnd:
.ASSERT VermilionGymGuideTextEnd - VermilionGymGymGuideText == 35
