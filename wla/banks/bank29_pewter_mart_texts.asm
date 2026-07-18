PewterMartYoungsterText:
	.DB $08 ; text_asm
	LD HL, PewterMartYoungsterText.Text
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd
PewterMartYoungsterText.Text:
	.DB $17
	.DW $45AC
	.DB $26,$50

PewterMartSuperNerdText:
	.DB $08 ; text_asm
	LD HL, PewterMartSuperNerdText.Text
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd
PewterMartSuperNerdText.Text:
	.DB $17
	.DW $460C
	.DB $26,$50
PewterMartTextsEnd:
.ASSERT PewterMartTextsEnd - PewterMartYoungsterText == 30
