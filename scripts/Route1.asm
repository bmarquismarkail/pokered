Route1_Script:
	jp EnableAutoTextBoxDrawing

Route1_TextPointers:
	def_text_pointers
	dw_const Route1Youngster1Text, TEXT_ROUTE1_YOUNGSTER1
	dw_const Route1Youngster2Text, TEXT_ROUTE1_YOUNGSTER2
	dw_const Route1SignText,       TEXT_ROUTE1_SIGN

Route1Youngster1Text:
	text_asm
	CheckAndSetEvent EVENT_GOT_POTION_SAMPLE
	jr nz, Route1Youngster1Text.got_item
	ld hl, Route1Youngster1Text.MartSampleText
	call PrintText
	lb "bc", POTION, 1
	call GiveItem
	jr nc, Route1Youngster1Text.bag_full
	ld hl, Route1Youngster1Text.GotPotionText
	jr Route1Youngster1Text.done
Route1Youngster1Text.bag_full
	ld hl, Route1Youngster1Text.NoRoomText
	jr Route1Youngster1Text.done
Route1Youngster1Text.got_item
	ld hl, Route1Youngster1Text.AlsoGotPokeballsText
Route1Youngster1Text.done
	call PrintText
	jp TextScriptEnd

Route1Youngster1Text.MartSampleText:
	text_far WLA_GLOBAL_Route1Youngster1MartSampleText
	text_end

Route1Youngster1Text.GotPotionText:
	text_far WLA_GLOBAL_Route1Youngster1GotPotionText
	sound_get_item_1
	text_end

Route1Youngster1Text.AlsoGotPokeballsText:
	text_far WLA_GLOBAL_Route1Youngster1AlsoGotPokeballsText
	text_end

Route1Youngster1Text.NoRoomText:
	text_far WLA_GLOBAL_Route1Youngster1NoRoomText
	text_end

Route1Youngster2Text:
	text_far WLA_GLOBAL_Route1Youngster2Text
	text_end

Route1SignText:
	text_far WLA_GLOBAL_Route1SignText
	text_end
