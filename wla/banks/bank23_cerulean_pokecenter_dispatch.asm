CeruleanPokecenter_Script:
	CALL $22FA ; Serial_TryEstablishingExternallyClockedConnection
	JP $3C3C ; EnableAutoTextBoxDrawing
CeruleanPokecenterScriptEnd:
.ASSERT CeruleanPokecenterScriptEnd - CeruleanPokecenter_Script == 6

CeruleanPokecenter_TextPointers:
.DW $4654 ; CeruleanPokecenterNurseText
.DW $4655 ; CeruleanPokecenterSuperNerdText
.DW $465A ; CeruleanPokecenterGentlemanText
.DW $4653 ; CeruleanPokecenterLinkReceptionistText
CeruleanPokecenterTextPointersEnd:
.ASSERT CeruleanPokecenterTextPointersEnd - CeruleanPokecenter_TextPointers == 8

CeruleanPokecenterLinkReceptionistText:
	.DB $F6
CeruleanPokecenterNurseText:
	.DB $FF
CeruleanPokecenterSuperNerdText:
	.DB $17
	.DW $48E5
	.DB $26, $50
CeruleanPokecenterGentlemanText:
	.DB $17
	.DW $492A
	.DB $26, $50
CeruleanPokecenterTextsEnd:
.ASSERT CeruleanPokecenterTextsEnd - CeruleanPokecenterLinkReceptionistText == 12
