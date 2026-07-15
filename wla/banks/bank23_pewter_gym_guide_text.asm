; Pewter Gym Guide handler and its five far-text records.
PewterGymGuideText:
	.DB $08 ; text_asm
	LD A, ($D72A) ; wBeatGymFlags
	BIT 0, A ; BIT_BOULDERBADGE
	JR NZ, PewterGymGuideText.afterBeat
	LD HL, PewterGymGuidePreAdviceText
	CALL PrintText
	CALL $35EC ; YesNoChoice
	LD A, ($CC26) ; wCurrentMenuItem
	AND A
	JR NZ, PewterGymGuideText.PewterGymGuideBeginAdviceText
	LD HL, PewterGymGuideBeginAdviceText
	CALL PrintText
	JR PewterGymGuideText.PewterGymGuideAdviceText
PewterGymGuideText.PewterGymGuideBeginAdviceText:
	LD HL, PewterGymGuideFreeServiceText
	CALL PrintText
PewterGymGuideText.PewterGymGuideAdviceText:
	LD HL, PewterGymGuideAdviceText
	CALL PrintText
	JR PewterGymGuideText.done
PewterGymGuideText.afterBeat:
	LD HL, PewterGymGuidePostBattleText
	CALL PrintText
PewterGymGuideText.done:
	JP $24D7 ; TextScriptEnd

PewterGymGuidePreAdviceText:
	.DB $17
	.DW $4351
	.DB $26, $50
PewterGymGuideBeginAdviceText:
	.DB $17
	.DW $43DC
	.DB $26, $50
PewterGymGuideAdviceText:
	.DB $17
	.DW $43FC
	.DB $26, $50
PewterGymGuideFreeServiceText:
	.DB $17
	.DW $4476
	.DB $26, $50
PewterGymGuidePostBattleText:
	.DB $17
	.DW $449F
	.DB $26, $50
PewterGymGuideTextEnd:
.ASSERT PewterGymGuideTextEnd - PewterGymGuideText == 79
