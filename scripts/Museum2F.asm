Museum2F_Script:
	jp EnableAutoTextBoxDrawing

Museum2F_TextPointers:
	def_text_pointers
	dw_const Museum2FYoungsterText,        TEXT_MUSEUM2F_YOUNGSTER
	dw_const Museum2FGrampsText,           TEXT_MUSEUM2F_GRAMPS
	dw_const Museum2FScientistText,        TEXT_MUSEUM2F_SCIENTIST
	dw_const Museum2FBrunetteGirlText,     TEXT_MUSEUM2F_BRUNETTE_GIRL
	dw_const Museum2FHikerText,            TEXT_MUSEUM2F_HIKER
	dw_const Museum2FSpaceShuttleSignText, TEXT_MUSEUM2F_SPACE_SHUTTLE_SIGN
	dw_const Museum2FMoonStoneSignText,    TEXT_MUSEUM2F_MOON_STONE_SIGN

Museum2FYoungsterText:
	text_far WLA_GLOBAL_Museum2FYoungsterText
	text_end

Museum2FGrampsText:
	text_far WLA_GLOBAL_Museum2FGrampsText
	text_end

Museum2FScientistText:
	text_far WLA_GLOBAL_Museum2FScientistText
	text_end

Museum2FBrunetteGirlText:
	text_far WLA_GLOBAL_Museum2FBrunetteGirlText
	text_end

Museum2FHikerText:
	text_far WLA_GLOBAL_Museum2FHikerText
	text_end

Museum2FSpaceShuttleSignText:
	text_far WLA_GLOBAL_Museum2FSpaceShuttleSignText
	text_end

Museum2FMoonStoneSignText:
	text_far WLA_GLOBAL_Museum2FMoonStoneSignText
	text_end
