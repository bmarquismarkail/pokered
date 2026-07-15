LavenderPokecenter_Script:
	CALL $22FA
	JP $3C3C
LavenderPokecenterScriptEnd:
.ASSERT LavenderPokecenterScriptEnd - LavenderPokecenter_Script == 6

LavenderPokecenter_TextPointers:
.DW $48E9, $48EA, $48EF, $48E8
LavenderPokecenterTextPointersEnd:
.ASSERT LavenderPokecenterTextPointersEnd - LavenderPokecenter_TextPointers == 8

LavenderPokecenterLinkReceptionistText:
	.DB $F6
LavenderPokecenterNurseText:
	.DB $FF
LavenderPokecenterGentlemanText:
	.DB $17
	.DW $540E
	.DB $26, $50
LavenderPokecenterLittleGirlText:
	.DB $17
	.DW $5442
	.DB $26, $50
LavenderPokecenterTextsEnd:
.ASSERT LavenderPokecenterTextsEnd - LavenderPokecenterLinkReceptionistText == 12
