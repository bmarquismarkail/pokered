MrFujisHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

MrFujisHouse_TextPointers:
	def_text_pointers
	dw_const MrFujisHouseSuperNerdText,     TEXT_MRFUJISHOUSE_SUPER_NERD
	dw_const MrFujisHouseLittleGirlText,    TEXT_MRFUJISHOUSE_LITTLE_GIRL
	dw_const MrFujisHousePsyduckText,       TEXT_MRFUJISHOUSE_PSYDUCK
	dw_const MrFujisHouseNidorinoText,      TEXT_MRFUJISHOUSE_NIDORINO
	dw_const MrFujisHouseMrFujiText,        TEXT_MRFUJISHOUSE_MR_FUJI
	dw_const MrFujisHouseMrFujiPokedexText, TEXT_MRFUJISHOUSE_POKEDEX

MrFujisHouseSuperNerdText:
	text_asm
	CheckEvent EVENT_RESCUED_MR_FUJI
	jr nz, MrFujisHouseSuperNerdText.rescued_mr_fuji
	ld hl, MrFujisHouseSuperNerdText.MrFujiIsntHereText
	call PrintText
	jr MrFujisHouseSuperNerdText.done
MrFujisHouseSuperNerdText.rescued_mr_fuji
	ld hl, MrFujisHouseSuperNerdText.MrFujiHadBeenPrayingText
	call PrintText
MrFujisHouseSuperNerdText.done
	jp TextScriptEnd

MrFujisHouseSuperNerdText.MrFujiIsntHereText:
	text_far WLA_GLOBAL_MrFujisHouseSuperNerdMrFujiIsntHereText
	text_end

MrFujisHouseSuperNerdText.MrFujiHadBeenPrayingText:
	text_far WLA_GLOBAL_MrFujisHouseSuperNerdMrFujiHadBeenPrayingText
	text_end

MrFujisHouseLittleGirlText:
	text_asm
	CheckEvent EVENT_RESCUED_MR_FUJI
	jr nz, MrFujisHouseLittleGirlText.rescued_mr_fuji
	ld hl, MrFujisHouseLittleGirlText.ThisIsMrFujisHouseText
	call PrintText
	jr MrFujisHouseLittleGirlText.done
MrFujisHouseLittleGirlText.rescued_mr_fuji
	ld hl, MrFujisHouseLittleGirlText.PokemonAreNiceToHugText
	call PrintText
MrFujisHouseLittleGirlText.done
	jp TextScriptEnd

MrFujisHouseLittleGirlText.ThisIsMrFujisHouseText:
	text_far WLA_GLOBAL_MrFujisHouseLittleGirlThisIsMrFujisHouseText
	text_end

MrFujisHouseLittleGirlText.PokemonAreNiceToHugText:
	text_far WLA_GLOBAL_MrFujisHouseLittleGirlPokemonAreNiceToHugText
	text_end

MrFujisHousePsyduckText:
	text_far WLA_GLOBAL_MrFujisHousePsyduckText
	text_asm
	ld a, PSYDUCK
	call PlayCry
	jp TextScriptEnd

MrFujisHouseNidorinoText:
	text_far WLA_GLOBAL_MrFujisHouseNidorinoText
	text_asm
	ld a, NIDORINO
	call PlayCry
	jp TextScriptEnd

MrFujisHouseMrFujiText:
	text_asm
	CheckEvent EVENT_GOT_POKE_FLUTE
	jr nz, MrFujisHouseMrFujiText.got_item
	ld hl, MrFujisHouseMrFujiText.IThinkThisMayHelpYourQuestText
	call PrintText
	lb "bc", POKE_FLUTE, 1
	call GiveItem
	jr nc, MrFujisHouseMrFujiText.bag_full
	ld hl, MrFujisHouseMrFujiText.ReceivedPokeFluteText
	call PrintText
	SetEvent EVENT_GOT_POKE_FLUTE
	jr MrFujisHouseMrFujiText.done
MrFujisHouseMrFujiText.bag_full
	ld hl, MrFujisHouseMrFujiText.PokeFluteNoRoomText
	call PrintText
	jr MrFujisHouseMrFujiText.done
MrFujisHouseMrFujiText.got_item
	ld hl, MrFujisHouseMrFujiText.HasMyFluteHelpedYouText
	call PrintText
MrFujisHouseMrFujiText.done
	jp TextScriptEnd

MrFujisHouseMrFujiText.IThinkThisMayHelpYourQuestText:
	text_far WLA_GLOBAL_MrFujisHouseMrFujiIThinkThisMayHelpYourQuestText
	text_end

MrFujisHouseMrFujiText.ReceivedPokeFluteText:
	text_far WLA_GLOBAL_MrFujisHouseMrFujiReceivedPokeFluteText
	sound_get_key_item
	text_far WLA_GLOBAL_MrFujisHouseMrFujiPokeFluteExplanationText
	text_end

MrFujisHouseMrFujiText.PokeFluteNoRoomText:
	text_far WLA_GLOBAL_MrFujisHouseMrFujiPokeFluteNoRoomText
	text_end

MrFujisHouseMrFujiText.HasMyFluteHelpedYouText:
	text_far WLA_GLOBAL_MrFujisHouseMrFujiHasMyFluteHelpedYouText
	text_end

MrFujisHouseMrFujiPokedexText:
	text_far WLA_GLOBAL_MrFujisHouseMrFujiPokedexText
	text_end
