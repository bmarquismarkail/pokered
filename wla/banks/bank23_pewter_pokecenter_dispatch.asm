; Pewter Pokecenter map script and text pointer table.
PewterPokecenter_Script:
	CALL $22FA ; Serial_TryEstablishingExternallyClockedConnection
	JP $3C3C ; EnableAutoTextBoxDrawing
PewterPokecenterScriptEnd:
.ASSERT PewterPokecenterScriptEnd - PewterPokecenter_Script == 6

PewterPokecenter_TextPointers:
.DW $4595 ; PewterPokecenterNurseText
.DW $4596 ; PewterPokecenterGentlemanText
.DW $459B ; PewterPokecenterJigglypuffText
.DW $460C ; PewterPokecenterLinkReceptionistText
PewterPokecenterTextPointersEnd:
.ASSERT PewterPokecenterTextPointersEnd - PewterPokecenter_TextPointers == 8
