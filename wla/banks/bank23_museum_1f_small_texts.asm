Museum1FScientist3Text:
.DB $08 ; text_asm
	LD HL, $42AD
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd
.DB $17
.DW $67E8 ; _Museum1FScientist3Text
.DB $25, $50
Museum1FScientist3TextEnd:
.ASSERT Museum1FScientist3TextEnd - Museum1FScientist3Text == 15

Museum1FOldAmberText:
.DB $08 ; text_asm
	LD HL, $42BC
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd
.DB $17
.DW $6823 ; _Museum1FOldAmberText
.DB $25, $50
Museum1FOldAmberTextEnd:
.ASSERT Museum1FOldAmberTextEnd - Museum1FOldAmberText == 15
