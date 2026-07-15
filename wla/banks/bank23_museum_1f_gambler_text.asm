Museum1FGamblerText:
.DB $08 ; text_asm
	LD HL, $4251 ; Museum1FGamblerText.Text
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd
Museum1FGamblerTextRecord:
.DB $17
.DW $6693 ; _Museum1FGamblerText
.DB $25, $50
Museum1FGamblerTextEnd:
.ASSERT Museum1FGamblerTextEnd - Museum1FGamblerText == 15
