Route16FlyHouse_Script:
	jp EnableAutoTextBoxDrawing

Route16FlyHouse_TextPointers:
	def_text_pointers
	dw_const Route16FlyHouseBrunetteGirlText, TEXT_ROUTE16FLYHOUSE_BRUNETTE_GIRL
	dw_const Route16FlyHouseFearowText,       TEXT_ROUTE16FLYHOUSE_FEAROW

Route16FlyHouseBrunetteGirlText:
	text_asm
	CheckEvent EVENT_GOT_HM02
	ld hl, Route16FlyHouseBrunetteGirlText.HM02ExplanationText
	jr nz, Route16FlyHouseBrunetteGirlText.got_item
	ld hl, Route16FlyHouseBrunetteGirlText.Text
	call PrintText
	lb "bc", HM_FLY, 1
	call GiveItem
	jr nc, Route16FlyHouseBrunetteGirlText.bag_full
	SetEvent EVENT_GOT_HM02
	ld hl, Route16FlyHouseBrunetteGirlText.ReceivedHM02Text
	jr Route16FlyHouseBrunetteGirlText.got_item
Route16FlyHouseBrunetteGirlText.bag_full
	ld hl, Route16FlyHouseBrunetteGirlText.HM02NoRoomText
Route16FlyHouseBrunetteGirlText.got_item
	call PrintText
	jp TextScriptEnd

Route16FlyHouseBrunetteGirlText.Text:
	text_far WLA_GLOBAL_Route16FlyHouseBrunetteGirlText
	text_end

Route16FlyHouseBrunetteGirlText.ReceivedHM02Text:
	text_far WLA_GLOBAL_Route16FlyHouseBrunetteGirlReceivedHM02Text
	sound_get_key_item
	text_end

Route16FlyHouseBrunetteGirlText.HM02ExplanationText:
	text_far WLA_GLOBAL_Route16FlyHouseBrunetteGirlHM02ExplanationText
	text_end

Route16FlyHouseBrunetteGirlText.HM02NoRoomText:
	text_far WLA_GLOBAL_Route16FlyHouseBrunetteGirlHM02NoRoomText
	text_end

Route16FlyHouseFearowText:
	text_asm
	ld hl, Route16FlyHouseFearowText.Text
	call PrintText
	ld a, FEAROW
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

Route16FlyHouseFearowText.Text:
	text_far WLA_GLOBAL_Route16FlyHouseFearowText
	text_end
