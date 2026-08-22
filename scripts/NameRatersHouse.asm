NameRatersHouse_Script:
	jp EnableAutoTextBoxDrawing

NameRatersHouseYesNoScript:
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ret

NameRatersHouseCheckMonOTScript:
; return carry if mon's OT name or OT ID do not match the player's
	ld hl, wPartyMonOT
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld de, wPlayerName
	ld c, NAME_LENGTH
	call NameRatersHouseCheckMonOTScript.check_match_loop
	jr c, NameRatersHouseCheckMonOTScript.no_match
	ld hl, wPartyMon1OTID
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld de, wPlayerID
	ld c, $2
NameRatersHouseCheckMonOTScript.check_match_loop
	ld a, [de]
	cp [hl]
	jr nz, NameRatersHouseCheckMonOTScript.no_match
	inc hl
	inc de
	dec c
	jr nz, NameRatersHouseCheckMonOTScript.check_match_loop
	and a
	ret
NameRatersHouseCheckMonOTScript.no_match
	scf
	ret

NameRatersHouse_TextPointers:
	def_text_pointers
	dw_const NameRatersHouseNameRaterText, TEXT_NAMERATERSHOUSE_NAME_RATER

NameRatersHouseNameRaterText:
	text_asm
	call SaveScreenTilesToBuffer2
	ld hl, NameRatersHouseNameRaterText.WantMeToRateText
	call NameRatersHouseYesNoScript
	jr nz, NameRatersHouseNameRaterText.did_not_rename
	ld hl, NameRatersHouseNameRaterText.WhichPokemonText
	call PrintText
	xor a
	ld [wPartyMenuTypeOrMessageID], a
	ld [wUpdateSpritesEnabled], a
	ld [wMenuItemToSwap], a
	call DisplayPartyMenu
	push af
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	pop af
	jr c, NameRatersHouseNameRaterText.did_not_rename
	call GetPartyMonName2
	call NameRatersHouseCheckMonOTScript
	ld hl, NameRatersHouseNameRaterText.ATrulyImpeccableNameText
	jr c, NameRatersHouseNameRaterText.done
	ld hl, NameRatersHouseNameRaterText.GiveItANiceNameText
	call NameRatersHouseYesNoScript
	jr nz, NameRatersHouseNameRaterText.did_not_rename
	ld hl, NameRatersHouseNameRaterText.WhatShouldWeNameItText
	call PrintText
	farcall DisplayNameRaterScreen
	jr c, NameRatersHouseNameRaterText.did_not_rename
	ld hl, NameRatersHouseNameRaterText.PokemonHasBeenRenamedText
NameRatersHouseNameRaterText.done
	call PrintText
	jp TextScriptEnd
NameRatersHouseNameRaterText.did_not_rename
	ld hl, NameRatersHouseNameRaterText.ComeAnyTimeYouLikeText
	jr NameRatersHouseNameRaterText.done

NameRatersHouseNameRaterText.WantMeToRateText:
	text_far WLA_GLOBAL_NameRatersHouseNameRaterWantMeToRateText
	text_end

NameRatersHouseNameRaterText.WhichPokemonText:
	text_far WLA_GLOBAL_NameRatersHouseNameRaterWhichPokemonText
	text_end

NameRatersHouseNameRaterText.GiveItANiceNameText:
	text_far WLA_GLOBAL_NameRatersHouseNameRaterGiveItANiceNameText
	text_end

NameRatersHouseNameRaterText.WhatShouldWeNameItText:
	text_far WLA_GLOBAL_NameRatersHouseNameRaterWhatShouldWeNameItText
	text_end

NameRatersHouseNameRaterText.PokemonHasBeenRenamedText:
	text_far WLA_GLOBAL_NameRatersHouseNameRaterPokemonHasBeenRenamedText
	text_end

NameRatersHouseNameRaterText.ComeAnyTimeYouLikeText:
	text_far WLA_GLOBAL_NameRatersHouseNameRaterComeAnyTimeYouLikeText
	text_end

NameRatersHouseNameRaterText.ATrulyImpeccableNameText:
	text_far WLA_GLOBAL_NameRatersHouseNameRaterATrulyImpeccableNameText
	text_end
