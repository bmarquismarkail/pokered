SaffronPokecenter_Script:
	CALL $22FA ; Serial_TryEstablishingExternallyClockedConnection
	JP $3C3C ; EnableAutoTextBoxDrawing
SaffronPokecenterScriptEnd:
.ASSERT SaffronPokecenterScriptEnd - SaffronPokecenter_Script == 6
