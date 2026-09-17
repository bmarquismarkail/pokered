WardensHouse_Script:
	jp EnableAutoTextBoxDrawing

WardensHouse_TextPointers:
	def_text_pointers
	dw_const WardensHouseWardenText,  TEXT_WARDENSHOUSE_WARDEN
	dw_const PickUpItemText,          TEXT_WARDENSHOUSE_RARE_CANDY
	dw_const BoulderText,             TEXT_WARDENSHOUSE_BOULDER
	dw_const WardensHouseDisplayText, TEXT_WARDENSHOUSE_DISPLAY_LEFT
	dw_const WardensHouseDisplayText, TEXT_WARDENSHOUSE_DISPLAY_RIGHT

WardensHouseWardenText:
	text_asm
	CheckEvent EVENT_GOT_HM04
	jr nz, WardensHouseWardenText.got_item
	ld b, GOLD_TEETH
	call IsItemInBag
	jr nz, WardensHouseWardenText.have_gold_teeth
	CheckEvent EVENT_GAVE_GOLD_TEETH
	jr nz, WardensHouseWardenText.gave_gold_teeth
	ld hl, WardensHouseWardenText.Gibberish1Text
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, WardensHouseWardenText.Gibberish3Text
	jr nz, WardensHouseWardenText.refused
	ld hl, WardensHouseWardenText.Gibberish2Text
WardensHouseWardenText.refused
	call PrintText
	jr WardensHouseWardenText.done
WardensHouseWardenText.have_gold_teeth
	ld hl, WardensHouseWardenText.GaveTheGoldTeethText
	call PrintText
	ld a, GOLD_TEETH
	ldh [lobyte(hItemToRemoveID)], a
	farcall RemoveItemByID
	SetEvent EVENT_GAVE_GOLD_TEETH
WardensHouseWardenText.gave_gold_teeth
	ld hl, WardensHouseWardenText.ThanksText
	call PrintText
	lb "bc", HM_STRENGTH, 1
	call GiveItem
	jr nc, WardensHouseWardenText.bag_full
	ld hl, WardensHouseWardenText.ReceivedHM04Text
	call PrintText
	SetEvent EVENT_GOT_HM04
	jr WardensHouseWardenText.done
WardensHouseWardenText.got_item
	ld hl, WardensHouseWardenText.HM04ExplanationText
	call PrintText
	jr WardensHouseWardenText.done
WardensHouseWardenText.bag_full
	ld hl, WardensHouseWardenText.HM04NoRoomText
	call PrintText
WardensHouseWardenText.done
	jp TextScriptEnd

WardensHouseWardenText.Gibberish1Text:
	text_far WLA_GLOBAL_WardensHouseWardenGibberish1Text
	text_end

WardensHouseWardenText.Gibberish2Text:
	text_far WLA_GLOBAL_WardensHouseWardenGibberish2Text
	text_end

WardensHouseWardenText.Gibberish3Text:
	text_far WLA_GLOBAL_WardensHouseWardenGibberish3Text
	text_end

WardensHouseWardenText.GaveTheGoldTeethText:
	text_far WLA_GLOBAL_WardensHouseWardenGaveTheGoldTeethText
	sound_get_item_1

WardensHouseWardenText.PoppedInHisTeethText: ; unreferenced
	text_far WLA_GLOBAL_WardensHouseWardenTeethPoppedInHisTeethText
	text_end

WardensHouseWardenText.ThanksText:
	text_far WLA_GLOBAL_WardensHouseWardenThanksText
	text_end

WardensHouseWardenText.ReceivedHM04Text:
	text_far WLA_GLOBAL_WardensHouseWardenReceivedHM04Text
	sound_get_item_1
	text_end

WardensHouseWardenText.HM04ExplanationText:
	text_far WLA_GLOBAL_WardensHouseWardenHM04ExplanationText
	text_end

WardensHouseWardenText.HM04NoRoomText:
	text_far WLA_GLOBAL_WardensHouseWardenHM04NoRoomText
	text_end

WardensHouseDisplayText:
	text_asm
	ldh a, [lobyte(hTextID)]
	cp TEXT_WARDENSHOUSE_DISPLAY_LEFT
	ld hl, WardensHouseDisplayText.MerchandiseText
	jr nz, WardensHouseDisplayText.print_text
	ld hl, WardensHouseDisplayText.PhotosAndFossilsText
WardensHouseDisplayText.print_text
	call PrintText
	jp TextScriptEnd

WardensHouseDisplayText.PhotosAndFossilsText:
	text_far WLA_GLOBAL_WardensHouseDisplayPhotosAndFossilsText
	text_end

WardensHouseDisplayText.MerchandiseText:
	text_far WLA_GLOBAL_WardensHouseDisplayMerchandiseText
	text_end
