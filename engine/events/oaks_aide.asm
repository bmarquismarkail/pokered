OaksAideScript:
	ld hl, OaksAideHiText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, OaksAideScript.choseNo
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ldh [lobyte(hOaksAideNumMonsOwned)], a
	ld b, a
	ldh a, [lobyte(hOaksAideRequirement)]
	cp b
	jr z, OaksAideScript.giveItem
	jr nc, OaksAideScript.notEnoughOwnedMons
OaksAideScript.giveItem
	ld hl, OaksAideHereYouGoText
	call PrintText
	ldh a, [lobyte(hOaksAideRewardItem)]
	ld b, a
	ld c, 1
	call GiveItem
	jr nc, OaksAideScript.bagFull
	ld hl, OaksAideGotItemText
	call PrintText
	ld a, OAKS_AIDE_GOT_ITEM
	jr OaksAideScript.done
OaksAideScript.bagFull
	ld hl, OaksAideNoRoomText
	call PrintText
	xor a ; OAKS_AIDE_BAG_FULL
	jr OaksAideScript.done
OaksAideScript.notEnoughOwnedMons
	ld hl, OaksAideUhOhText
	call PrintText
	ld a, OAKS_AIDE_NOT_ENOUGH_MONS
	jr OaksAideScript.done
OaksAideScript.choseNo
	ld hl, OaksAideComeBackText
	call PrintText
	ld a, OAKS_AIDE_REFUSED
OaksAideScript.done
	ldh [lobyte(hOaksAideResult)], a
	ret

OaksAideHiText:
	text_far WLA_GLOBAL_OaksAideHiText
	text_end

OaksAideUhOhText:
	text_far WLA_GLOBAL_OaksAideUhOhText
	text_end

OaksAideComeBackText:
	text_far WLA_GLOBAL_OaksAideComeBackText
	text_end

OaksAideHereYouGoText:
	text_far WLA_GLOBAL_OaksAideHereYouGoText
	text_end

OaksAideGotItemText:
	text_far WLA_GLOBAL_OaksAideGotItemText
	sound_get_item_1
	text_end

OaksAideNoRoomText:
	text_far WLA_GLOBAL_OaksAideNoRoomText
	text_end
