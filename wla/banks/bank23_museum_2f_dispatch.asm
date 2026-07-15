Museum2F_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
Museum2FScriptEnd:
.ASSERT Museum2FScriptEnd - Museum2F_Script == 3

Museum2F_TextPointers:
.DW $4328 ; Museum2FYoungsterText
.DW $432D ; Museum2FGrampsText
.DW $4332 ; Museum2FScientistText
.DW $4337 ; Museum2FBrunetteGirlText
.DW $433C ; Museum2FHikerText
.DW $4341 ; Museum2FMoonStoneText
.DW $4346 ; Museum2FAerodactylText
Museum2FTextPointersEnd:
.ASSERT Museum2FTextPointersEnd - Museum2F_TextPointers == 14
