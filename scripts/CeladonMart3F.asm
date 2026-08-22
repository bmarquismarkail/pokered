CeladonMart3F_Script:
	jp EnableAutoTextBoxDrawing

CeladonMart3F_TextPointers:
	def_text_pointers
	dw_const CeladonMart3FClerkText,            TEXT_CELADONMART3F_CLERK
	dw_const CeladonMart3FGameBoyKid1Text,      TEXT_CELADONMART3F_GAMEBOY_KID1
	dw_const CeladonMart3FGameBoyKid2Text,      TEXT_CELADONMART3F_GAMEBOY_KID2
	dw_const CeladonMart3FGameBoyKid3Text,      TEXT_CELADONMART3F_GAMEBOY_KID3
	dw_const CeladonMart3FLittleBoyText,        TEXT_CELADONMART3F_LITTLE_BOY
	dw_const CeladonMart3FSNESText,             TEXT_CELADONMART3F_SNES1
	dw_const CeladonMart3FRPGText,              TEXT_CELADONMART3F_RPG
	dw_const CeladonMart3FSNESText,             TEXT_CELADONMART3F_SNES2
	dw_const CeladonMart3FSportsGameText,       TEXT_CELADONMART3F_SPORTS_GAME
	dw_const CeladonMart3FSNESText,             TEXT_CELADONMART3F_SNES3
	dw_const CeladonMart3FPuzzleGameText,       TEXT_CELADONMART3F_PUZZLE_GAME
	dw_const CeladonMart3FSNESText,             TEXT_CELADONMART3F_SNES4
	dw_const CeladonMart3FFightingGameText,     TEXT_CELADONMART3F_FIGHTING_GAME
	dw_const CeladonMart3FCurrentFloorSignText, TEXT_CELADONMART3F_CURRENT_FLOOR_SIGN
	dw_const CeladonMart3FPokemonPosterText,    TEXT_CELADONMART3F_POKEMON_POSTER1
	dw_const CeladonMart3FPokemonPosterText,    TEXT_CELADONMART3F_POKEMON_POSTER2
	dw_const CeladonMart3FPokemonPosterText,    TEXT_CELADONMART3F_POKEMON_POSTER3

CeladonMart3FClerkText:
	text_asm
	CheckEvent EVENT_GOT_TM18
	jr nz, CeladonMart3FClerkText.got_item
	ld hl, CeladonMart3FClerkText.TM18PreReceiveText
	call PrintText
	lb "bc", TM_COUNTER, 1
	call GiveItem
	jr nc, CeladonMart3FClerkText.bag_full
	SetEvent EVENT_GOT_TM18
	ld hl, CeladonMart3FClerkText.ReceivedTM18Text
	jr CeladonMart3FClerkText.done
CeladonMart3FClerkText.bag_full
	ld hl, CeladonMart3FClerkText.TM18NoRoomText
	jr CeladonMart3FClerkText.done
CeladonMart3FClerkText.got_item
	ld hl, CeladonMart3FClerkText.TM18ExplanationText
CeladonMart3FClerkText.done
	call PrintText
	jp TextScriptEnd

CeladonMart3FClerkText.TM18PreReceiveText:
	text_far WLA_GLOBAL_CeladonMart3FClerkTM18PreReceiveText
	text_end

CeladonMart3FClerkText.ReceivedTM18Text:
	text_far WLA_GLOBAL_CeladonMart3FClerkReceivedTM18Text
	sound_get_item_1
	text_end

CeladonMart3FClerkText.TM18ExplanationText:
	text_far WLA_GLOBAL_CeladonMart3FClerkTM18ExplanationText
	text_end

CeladonMart3FClerkText.TM18NoRoomText:
	text_far WLA_GLOBAL_CeladonMart3FClerkTM18NoRoomText
	text_end

CeladonMart3FGameBoyKid1Text:
	text_far WLA_GLOBAL_CeladonMart3FGameBoyKid1Text
	text_end

CeladonMart3FGameBoyKid2Text:
	text_far WLA_GLOBAL_CeladonMart3FGameBoyKid2Text
	text_end

CeladonMart3FGameBoyKid3Text:
	text_far WLA_GLOBAL_CeladonMart3FGameBoyKid3Text
	text_end

CeladonMart3FLittleBoyText:
	text_far WLA_GLOBAL_CeladonMart3FLittleBoyText
	text_end

CeladonMart3FSNESText:
	text_far WLA_GLOBAL_CeladonMart3FSNESText
	text_end

CeladonMart3FRPGText:
	text_far WLA_GLOBAL_CeladonMart3FRPGText
	text_end

CeladonMart3FSportsGameText:
	text_far WLA_GLOBAL_CeladonMart3FSportsGameText
	text_end

CeladonMart3FPuzzleGameText:
	text_far WLA_GLOBAL_CeladonMart3FPuzzleGameText
	text_end

CeladonMart3FFightingGameText:
	text_far WLA_GLOBAL_CeladonMart3FFightingGameText
	text_end

CeladonMart3FCurrentFloorSignText:
	text_far WLA_GLOBAL_CeladonMart3FCurrentFloorSignText
	text_end

CeladonMart3FPokemonPosterText:
	text_far WLA_GLOBAL_CeladonMart3FPokemonPosterText
	text_end
