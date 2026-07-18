FuchsiaPokecenter_Script:
	CALL $22FA ; Serial_TryEstablishingExternallyClockedConnection
	JP $3C3C ; EnableAutoTextBoxDrawing
FuchsiaPokecenterScriptEnd:
.ASSERT FuchsiaPokecenterScriptEnd - FuchsiaPokecenter_Script == 6

FuchsiaPokecenter_TextPointers:
	.DW FuchsiaPokecenterNurseText
	.DW FuchsiaPokecenterRockerText
	.DW FuchsiaPokecenterCooltrainerFText
	.DW FuchsiaPokecenterLinkReceptionistText
FuchsiaPokecenterTextPointersEnd:
.ASSERT FuchsiaPokecenterTextPointersEnd - FuchsiaPokecenter_TextPointers == 8
