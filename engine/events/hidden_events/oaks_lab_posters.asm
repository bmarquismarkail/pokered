DisplayOakLabLeftPoster:
	call EnableAutoTextBoxDrawing
	tx_pre_jump PushStartText

PushStartText:
	text_far WLA_GLOBAL_PushStartText
	text_end

DisplayOakLabRightPoster:
	call EnableAutoTextBoxDrawing
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 2
	tx_pre_id SaveOptionText
	jr c, DisplayOakLabRightPoster.ownLessThanTwo
	; own two or more mon
	tx_pre_id StrengthsAndWeaknessesText
DisplayOakLabRightPoster.ownLessThanTwo
	jp PrintPredefTextID

SaveOptionText:
	text_far WLA_GLOBAL_SaveOptionText
	text_end

StrengthsAndWeaknessesText:
	text_far WLA_GLOBAL_StrengthsAndWeaknessesText
	text_end
