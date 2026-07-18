CinnabarPokecenter_Script:
	CALL $22FA ; Serial_TryEstablishingExternallyClockedConnection
	JP $3C3C ; EnableAutoTextBoxDrawing
CinnabarPokecenterScriptEnd:
.ASSERT CinnabarPokecenterScriptEnd - CinnabarPokecenter_Script == 6

CinnabarPokecenter_TextPointers:
	.DW CinnabarPokecenterNurseText,CinnabarPokecenterCooltrainerFText
	.DW CinnabarPokecenterGentlemanText,CinnabarPokecenterLinkReceptionistText
CinnabarPokecenterTextPointersEnd:
.ASSERT CinnabarPokecenterTextPointersEnd - CinnabarPokecenter_TextPointers == 8
