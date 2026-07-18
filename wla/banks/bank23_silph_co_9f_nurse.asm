SilphCo9FNurseText:
	.DB $08
	LD A, ($D838)
	BIT 7, A ; EVENT_BEAT_SILPH_CO_GIOVANNI
	JR NZ, SilphCo9FNurseText.beat_giovanni
	LD HL, SilphCo9FNurseText.YouLookTiredText
	CALL $3C49 ; PrintText
	LD A, $07 ; HealParty predef
	CALL $3E6D
	CALL $20D8 ; GBFadeOutToWhite
	CALL $3DD7 ; Delay3
	CALL $20F6 ; GBFadeInFromWhite
	LD HL, SilphCo9FNurseText.DontGiveUpText
	CALL $3C49
	JR SilphCo9FNurseText.text_script_end
SilphCo9FNurseText.beat_giovanni:
	LD HL, SilphCo9FNurseText.ThankYouText
	CALL $3C49
SilphCo9FNurseText.text_script_end:
	JP $24D7 ; TextScriptEnd
SilphCo9FNurseText.YouLookTiredText:
	.DB $17
	.DW $4C0B
	.DB $21, $50
SilphCo9FNurseText.DontGiveUpText:
	.DB $17
	.DW $4C39
	.DB $21, $50
SilphCo9FNurseText.ThankYouText:
	.DB $17
	.DW $4C48
	.DB $21, $50
SilphCo9FNurseEnd:
.ASSERT SilphCo9FNurseEnd - SilphCo9FNurseText == 60
