VermilionPokecenter_Script:
	CALL $22FA
	JP $3C3C
VermilionPokecenterScriptEnd:
.ASSERT VermilionPokecenterScriptEnd - VermilionPokecenter_Script == 6

VermilionPokecenter_TextPointers:
.DW $499D, $499E, $49A3, $49A8
VermilionPokecenterTextPointersEnd:
.ASSERT VermilionPokecenterTextPointersEnd - VermilionPokecenter_TextPointers == 8

VermilionPokecenterNurseText:
	.DB $FF
VermilionPokecenterFishingGuruText:
	.DB $17
	.DW $64B2
	.DB $26, $50
VermilionPokecenterSailorText:
	.DB $17
	.DW $6539
	.DB $26, $50
VermilionPokecenterLinkReceptionistText:
	.DB $F6
VermilionPokecenterTextsEnd:
.ASSERT VermilionPokecenterTextsEnd - VermilionPokecenterNurseText == 12
