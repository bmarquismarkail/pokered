ViridianGymGymGuideText:
	.DB $08 ; text_asm
	LD A, ($D751)
	BIT 1, A ; EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	JR NZ, ViridianGymGymGuideText.afterBeat
	LD HL, ViridianGymGuidePreBattleText
	CALL $3C49 ; PrintText
	JR ViridianGymGymGuideText.done
ViridianGymGymGuideText.afterBeat:
	LD HL, ViridianGymGuidePostBattleText
	CALL $3C49 ; PrintText
ViridianGymGymGuideText.done:
	JP $24D7 ; TextScriptEnd

ViridianGymGuidePreBattleText:
	.DB $17
	.DW $6451
	.DB $25,$50
ViridianGymGuidePostBattleText:
	.DB $17
	.DW $64FB
	.DB $25,$50
ViridianGymGuideTextEnd:
.ASSERT ViridianGymGuideTextEnd - ViridianGymGymGuideText == 35
