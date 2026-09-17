PokemonFanClub_Script:
	jp EnableAutoTextBoxDrawing

PokemonFanClub_CheckBikeInBag:
; check if any bike paraphernalia in bag
	CheckEvent EVENT_GOT_BIKE_VOUCHER
	ret nz
	ld b, BICYCLE
	call IsItemInBag
	ret nz
	ld b, BIKE_VOUCHER
	jp IsItemInBag

PokemonFanClub_TextPointers:
	def_text_pointers
	dw_const PokemonFanClubPikachuFanText,   TEXT_POKEMONFANCLUB_PIKACHU_FAN
	dw_const PokemonFanClubSeelFanText,      TEXT_POKEMONFANCLUB_SEEL_FAN
	dw_const PokemonFanClubPikachuText,      TEXT_POKEMONFANCLUB_PIKACHU
	dw_const PokemonFanClubSeelText,         TEXT_POKEMONFANCLUB_SEEL
	dw_const PokemonFanClubChairmanText,     TEXT_POKEMONFANCLUB_CHAIRMAN
	dw_const PokemonFanClubReceptionistText, TEXT_POKEMONFANCLUB_RECEPTIONIST
	dw_const PokemonFanClubSign1Text,        TEXT_POKEMONFANCLUB_SIGN_1
	dw_const PokemonFanClubSign2Text,        TEXT_POKEMONFANCLUB_SIGN_2

PokemonFanClubPikachuFanText:
	text_asm
	CheckEvent EVENT_PIKACHU_FAN_BOAST
	jr nz, PokemonFanClubPikachuFanText.mineisbetter
	ld hl, PokemonFanClubPikachuFanText.NormalText
	call PrintText
	SetEvent EVENT_SEEL_FAN_BOAST
	jr PokemonFanClubPikachuFanText.done
PokemonFanClubPikachuFanText.mineisbetter
	ld hl, PokemonFanClubPikachuFanText.BetterText
	call PrintText
	ResetEvent EVENT_PIKACHU_FAN_BOAST
PokemonFanClubPikachuFanText.done
	jp TextScriptEnd

PokemonFanClubPikachuFanText.NormalText:
	text_far WLA_GLOBAL_PokemonFanClubPikachuFanNormalText
	text_end

PokemonFanClubPikachuFanText.BetterText:
	text_far WLA_GLOBAL_PokemonFanClubPikachuFanBetterText
	text_end

PokemonFanClubSeelFanText:
	text_asm
	CheckEvent EVENT_SEEL_FAN_BOAST
	jr nz, PokemonFanClubSeelFanText.mineisbetter
	ld hl, PokemonFanClubSeelFanText.NormalText
	call PrintText
	SetEvent EVENT_PIKACHU_FAN_BOAST
	jr PokemonFanClubSeelFanText.done
PokemonFanClubSeelFanText.mineisbetter
	ld hl, PokemonFanClubSeelFanText.BetterText
	call PrintText
	ResetEvent EVENT_SEEL_FAN_BOAST
PokemonFanClubSeelFanText.done
	jp TextScriptEnd

PokemonFanClubSeelFanText.NormalText:
	text_far WLA_GLOBAL_PokemonFanClubSeelFanNormalText
	text_end

PokemonFanClubSeelFanText.BetterText:
	text_far WLA_GLOBAL_PokemonFanClubSeelFanBetterText
	text_end

PokemonFanClubPikachuText:
	text_asm
	ld hl, PokemonFanClubPikachuText.Text
	call PrintText
	ld a, PIKACHU
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

PokemonFanClubPikachuText.Text
	text_far WLA_GLOBAL_PokemonFanClubPikachuText
	text_end

PokemonFanClubSeelText:
	text_asm
	ld hl, PokemonFanClubSeelText.Text
	call PrintText
	ld a, SEEL
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

PokemonFanClubSeelText.Text:
	text_far WLA_GLOBAL_PokemonFanClubSeelText
	text_end

PokemonFanClubChairmanText:
	text_asm
	call PokemonFanClub_CheckBikeInBag
	jr nz, PokemonFanClubChairmanText.nothingleft

	ld hl, PokemonFanClubChairmanText.IntroText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, PokemonFanClubChairmanText.nothanks

	; tell the story
	ld hl, PokemonFanClubChairmanText.StoryText
	call PrintText
	lb "bc", BIKE_VOUCHER, 1
	call GiveItem
	jr nc, PokemonFanClubChairmanText.bag_full
	ld hl, PokemonFanClubChairmanText.BikeVoucherText
	call PrintText
	SetEvent EVENT_GOT_BIKE_VOUCHER
	jr PokemonFanClubChairmanText.done
PokemonFanClubChairmanText.bag_full
	ld hl, PokemonFanClubChairmanText.BagFullText
	call PrintText
	jr PokemonFanClubChairmanText.done
PokemonFanClubChairmanText.nothanks
	ld hl, PokemonFanClubChairmanText.NoStoryText
	call PrintText
	jr PokemonFanClubChairmanText.done
PokemonFanClubChairmanText.nothingleft
	ld hl, PokemonFanClubChairmanText.FinalText
	call PrintText
PokemonFanClubChairmanText.done
	jp TextScriptEnd

PokemonFanClubChairmanText.IntroText:
	text_far WLA_GLOBAL_PokemonFanClubChairmanIntroText
	text_end

PokemonFanClubChairmanText.StoryText:
	text_far WLA_GLOBAL_PokemonFanClubChairmanStoryText
	text_end

PokemonFanClubChairmanText.BikeVoucherText:
	text_far WLA_GLOBAL_PokemonFanClubReceivedBikeVoucherText
	sound_get_key_item
	text_far WLA_GLOBAL_PokemonFanClubExplainBikeVoucherText
	text_end

PokemonFanClubChairmanText.NoStoryText:
	text_far WLA_GLOBAL_PokemonFanClubNoStoryText
	text_end

PokemonFanClubChairmanText.FinalText:
	text_far WLA_GLOBAL_PokemonFanClubChairFinalText
	text_end

PokemonFanClubChairmanText.BagFullText:
	text_far WLA_GLOBAL_PokemonFanClubBagFullText
	text_end

PokemonFanClubReceptionistText:
	text_far WLA_GLOBAL_PokemonFanClubReceptionistText
	text_end

PokemonFanClubSign1Text:
	text_far WLA_GLOBAL_PokemonFanClubSign1Text
	text_end

PokemonFanClubSign2Text:
	text_far WLA_GLOBAL_PokemonFanClubSign2Text
	text_end
