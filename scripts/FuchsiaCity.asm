FuchsiaCity_Script:
	jp EnableAutoTextBoxDrawing

FuchsiaCity_TextPointers:
	def_text_pointers
	dw_const FuchsiaCityYoungster1Text,      TEXT_FUCHSIACITY_YOUNGSTER1
	dw_const FuchsiaCityGamblerText,         TEXT_FUCHSIACITY_GAMBLER
	dw_const FuchsiaCityErikText,            TEXT_FUCHSIACITY_ERIK
	dw_const FuchsiaCityYoungster2Text,      TEXT_FUCHSIACITY_YOUNGSTER2
	dw_const FuchsiaCityPokemonText,         TEXT_FUCHSIACITY_CHANSEY
	dw_const FuchsiaCityPokemonText,         TEXT_FUCHSIACITY_VOLTORB
	dw_const FuchsiaCityPokemonText,         TEXT_FUCHSIACITY_KANGASKHAN
	dw_const FuchsiaCityPokemonText,         TEXT_FUCHSIACITY_SLOWPOKE
	dw_const FuchsiaCityPokemonText,         TEXT_FUCHSIACITY_LAPRAS
	dw_const FuchsiaCityPokemonText,         TEXT_FUCHSIACITY_FOSSIL
	dw_const FuchsiaCitySignText,            TEXT_FUCHSIACITY_SIGN1
	dw_const FuchsiaCitySignText,            TEXT_FUCHSIACITY_SIGN2
	dw_const FuchsiaCitySafariGameSignText,  TEXT_FUCHSIACITY_SAFARI_GAME_SIGN
	dw_const MartSignText,                   TEXT_FUCHSIACITY_MART_SIGN
	dw_const PokeCenterSignText,             TEXT_FUCHSIACITY_POKECENTER_SIGN
	dw_const FuchsiaCityWardensHomeSignText, TEXT_FUCHSIACITY_WARDENS_HOME_SIGN
	dw_const FuchsiaCitySafariZoneSignText,  TEXT_FUCHSIACITY_SAFARI_ZONE_SIGN
	dw_const FuchsiaCityGymSignText,         TEXT_FUCHSIACITY_GYM_SIGN
	dw_const FuchsiaCityChanseySignText,     TEXT_FUCHSIACITY_CHANSEY_SIGN
	dw_const FuchsiaCityVoltorbSignText,     TEXT_FUCHSIACITY_VOLTORB_SIGN
	dw_const FuchsiaCityKangaskhanSignText,  TEXT_FUCHSIACITY_KANGASKHAN_SIGN
	dw_const FuchsiaCitySlowpokeSignText,    TEXT_FUCHSIACITY_SLOWPOKE_SIGN
	dw_const FuchsiaCityLaprasSignText,      TEXT_FUCHSIACITY_LAPRAS_SIGN
	dw_const FuchsiaCityFossilSignText,      TEXT_FUCHSIACITY_FOSSIL_SIGN

FuchsiaCityYoungster1Text:
	text_far WLA_GLOBAL_FuchsiaCityYoungster1Text
	text_end

FuchsiaCityGamblerText:
	text_far WLA_GLOBAL_FuchsiaCityGamblerText
	text_end

FuchsiaCityErikText:
	text_far WLA_GLOBAL_FuchsiaCityErikText
	text_end

FuchsiaCityYoungster2Text:
	text_far WLA_GLOBAL_FuchsiaCityYoungster2Text
	text_end

FuchsiaCityPokemonText:
	text_far WLA_GLOBAL_FuchsiaCityPokemonText
	text_end

FuchsiaCitySignText:
	text_far WLA_GLOBAL_FuchsiaCitySignText
	text_end

FuchsiaCitySafariGameSignText:
	text_far WLA_GLOBAL_FuchsiaCitySafariGameSignText
	text_end

FuchsiaCityWardensHomeSignText:
	text_far WLA_GLOBAL_FuchsiaCityWardensHomeSignText
	text_end

FuchsiaCitySafariZoneSignText:
	text_far WLA_GLOBAL_FuchsiaCitySafariZoneSignText
	text_end

FuchsiaCityGymSignText:
	text_far WLA_GLOBAL_FuchsiaCityGymSignText
	text_end

FuchsiaCityChanseySignText:
	text_asm
	ld hl, FuchsiaCityChanseySignText.Text
	call PrintText
	ld a, CHANSEY
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCityChanseySignText.Text:
	text_far WLA_GLOBAL_FuchsiaCityChanseySignText
	text_end

FuchsiaCityVoltorbSignText:
	text_asm
	ld hl, FuchsiaCityVoltorbSignText.Text
	call PrintText
	ld a, VOLTORB
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCityVoltorbSignText.Text:
	text_far WLA_GLOBAL_FuchsiaCityVoltorbSignText
	text_end

FuchsiaCityKangaskhanSignText:
	text_asm
	ld hl, FuchsiaCityKangaskhanSignText.Text
	call PrintText
	ld a, KANGASKHAN
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCityKangaskhanSignText.Text:
	text_far WLA_GLOBAL_FuchsiaCityKangaskhanSignText
	text_end

FuchsiaCitySlowpokeSignText:
	text_asm
	ld hl, FuchsiaCitySlowpokeSignText.Text
	call PrintText
	ld a, SLOWPOKE
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCitySlowpokeSignText.Text:
	text_far WLA_GLOBAL_FuchsiaCitySlowpokeSignText
	text_end

FuchsiaCityLaprasSignText:
	text_asm
	ld hl, FuchsiaCityLaprasSignText.Text
	call PrintText
	ld a, LAPRAS
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCityLaprasSignText.Text:
	text_far WLA_GLOBAL_FuchsiaCityLaprasSignText
	text_end

FuchsiaCityFossilSignText:
	text_asm
	CheckEvent EVENT_GOT_DOME_FOSSIL
	jr nz, FuchsiaCityFossilSignText.got_dome_fossil
	CheckEventReuseA EVENT_GOT_HELIX_FOSSIL
	jr nz, FuchsiaCityFossilSignText.got_helix_fossil
	ld hl, FuchsiaCityFossilSignText.UndeterminedText
	call PrintText
	jr FuchsiaCityFossilSignText.done
FuchsiaCityFossilSignText.got_dome_fossil
	ld hl, FuchsiaCityFossilSignText.OmanyteText
	call PrintText
	ld a, OMANYTE
	jr FuchsiaCityFossilSignText.display
FuchsiaCityFossilSignText.got_helix_fossil
	ld hl, FuchsiaCityFossilSignText.KabutoText
	call PrintText
	ld a, KABUTO
FuchsiaCityFossilSignText.display
	call DisplayPokedex
FuchsiaCityFossilSignText.done
	jp TextScriptEnd

FuchsiaCityFossilSignText.OmanyteText:
	text_far WLA_GLOBAL_FuchsiaCityFossilSignOmanyteText
	text_end

FuchsiaCityFossilSignText.KabutoText:
	text_far WLA_GLOBAL_FuchsiaCityFossilSignKabutoText
	text_end

FuchsiaCityFossilSignText.UndeterminedText:
	text_far WLA_GLOBAL_FuchsiaCityFossilSignUndeterminedText
	text_end
