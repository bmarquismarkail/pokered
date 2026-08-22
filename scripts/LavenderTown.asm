LavenderTown_Script:
	jp EnableAutoTextBoxDrawing

LavenderTown_TextPointers:
	def_text_pointers
	dw_const LavenderTownLittleGirlText,       TEXT_LAVENDERTOWN_LITTLE_GIRL
	dw_const LavenderTownCooltrainerMText,     TEXT_LAVENDERTOWN_COOLTRAINER_M
	dw_const LavenderTownSuperNerdText,        TEXT_LAVENDERTOWN_SUPER_NERD
	dw_const LavenderTownSignText,             TEXT_LAVENDERTOWN_SIGN
	dw_const LavenderTownSilphScopeSignText,   TEXT_LAVENDERTOWN_SILPH_SCOPE_SIGN
	dw_const MartSignText,                     TEXT_LAVENDERTOWN_MART_SIGN
	dw_const PokeCenterSignText,               TEXT_LAVENDERTOWN_POKECENTER_SIGN
	dw_const LavenderTownPokemonHouseSignText, TEXT_LAVENDERTOWN_POKEMON_HOUSE_SIGN
	dw_const LavenderTownPokemonTowerSignText, TEXT_LAVENDERTOWN_POKEMON_TOWER_SIGN

LavenderTownLittleGirlText:
	text_asm
	ld hl, LavenderTownLittleGirlText.DoYouBelieveInGhostsText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, LavenderTownLittleGirlText.HaHaGuessNotText
	jr nz, LavenderTownLittleGirlText.got_text
	ld hl, LavenderTownLittleGirlText.SoThereAreBelieversText
LavenderTownLittleGirlText.got_text
	call PrintText
	jp TextScriptEnd

LavenderTownLittleGirlText.DoYouBelieveInGhostsText:
	text_far WLA_GLOBAL_LavenderTownLittleGirlDoYouBelieveInGhostsText
	text_end

LavenderTownLittleGirlText.SoThereAreBelieversText:
	text_far WLA_GLOBAL_LavenderTownLittleGirlSoThereAreBelieversText
	text_end

LavenderTownLittleGirlText.HaHaGuessNotText:
	text_far WLA_GLOBAL_LavenderTownLittleGirlHaHaGuessNotText
	text_end

LavenderTownCooltrainerMText:
	text_far WLA_GLOBAL_LavenderTownCooltrainerMText
	text_end

LavenderTownSuperNerdText:
	text_far WLA_GLOBAL_LavenderTownSuperNerdText
	text_end

LavenderTownSignText:
	text_far WLA_GLOBAL_LavenderTownSignText
	text_end

LavenderTownSilphScopeSignText:
	text_far WLA_GLOBAL_LavenderTownSilphScopeSignText
	text_end

LavenderTownPokemonHouseSignText:
	text_far WLA_GLOBAL_LavenderTownPokemonHouseSignText
	text_end

LavenderTownPokemonTowerSignText:
	text_far WLA_GLOBAL_LavenderTownPokemonTowerSignText
	text_end
