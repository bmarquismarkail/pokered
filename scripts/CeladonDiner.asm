CeladonDiner_Script:
	call EnableAutoTextBoxDrawing
	ret

CeladonDiner_TextPointers:
	def_text_pointers
	dw_const CeladonDinerCookText,            TEXT_CELADONDINER_COOK
	dw_const CeladonDinerMiddleAgedWomanText, TEXT_CELADONDINER_MIDDLE_AGED_WOMAN
	dw_const CeladonDinerMiddleAgedManText,   TEXT_CELADONDINER_MIDDLE_AGED_MAN
	dw_const CeladonDinerFisherText,          TEXT_CELADONDINER_FISHER
	dw_const CeladonDinerGymGuideText,        TEXT_CELADONDINER_GYM_GUIDE

CeladonDinerCookText:
	text_far WLA_GLOBAL_CeladonDinerCookText
	text_end

CeladonDinerMiddleAgedWomanText:
	text_far WLA_GLOBAL_CeladonDinerMiddleAgedWomanText
	text_end

CeladonDinerMiddleAgedManText:
	text_far WLA_GLOBAL_CeladonDinerMiddleAgedManText
	text_end

CeladonDinerFisherText:
	text_far WLA_GLOBAL_CeladonDinerFisherText
	text_end

CeladonDinerGymGuideText:
	text_asm
	CheckEvent EVENT_GOT_COIN_CASE
	jr nz, CeladonDinerGymGuideText.got_item
	ld hl, CeladonDinerGymGuideText.ImFlatOutBustedText
	call PrintText
	lb "bc", COIN_CASE, 1
	call GiveItem
	jr nc, CeladonDinerGymGuideText.bag_full
	SetEvent EVENT_GOT_COIN_CASE
	ld hl, CeladonDinerGymGuideText.ReceivedCoinCaseText
	call PrintText
	jr CeladonDinerGymGuideText.done
CeladonDinerGymGuideText.bag_full
	ld hl, CeladonDinerGymGuideText.CoinCaseNoRoomText
	call PrintText
	jr CeladonDinerGymGuideText.done
CeladonDinerGymGuideText.got_item
	ld hl, CeladonDinerGymGuideText.WinItBackText
	call PrintText
CeladonDinerGymGuideText.done
	jp TextScriptEnd

CeladonDinerGymGuideText.ImFlatOutBustedText:
	text_far WLA_GLOBAL_CeladonDinerGymGuideImFlatOutBustedText
	text_end

CeladonDinerGymGuideText.ReceivedCoinCaseText:
	text_far WLA_GLOBAL_CeladonDinerGymGuideReceivedCoinCaseText
	sound_get_key_item
	text_end

CeladonDinerGymGuideText.CoinCaseNoRoomText:
	text_far WLA_GLOBAL_CeladonDinerGymGuideCoinCaseNoRoomText
	text_end

CeladonDinerGymGuideText.WinItBackText:
	text_far WLA_GLOBAL_CeladonDinerGymGuideWinItBackText
	text_end
