CeladonCity_Script:
	call EnableAutoTextBoxDrawing
	ResetEvents EVENT_1B8, EVENT_1BF
	ResetEvent EVENT_67F
	ret

CeladonCity_TextPointers:
	def_text_pointers
	dw_const CeladonCityLittleGirlText,        TEXT_CELADONCITY_LITTLE_GIRL
	dw_const CeladonCityGramps1Text,           TEXT_CELADONCITY_GRAMPS1
	dw_const CeladonCityGirlText,              TEXT_CELADONCITY_GIRL
	dw_const CeladonCityGramps2Text,           TEXT_CELADONCITY_GRAMPS2
	dw_const CeladonCityGramps3Text,           TEXT_CELADONCITY_GRAMPS3
	dw_const CeladonCityFisherText,            TEXT_CELADONCITY_FISHER
	dw_const CeladonCityPoliwrathText,         TEXT_CELADONCITY_POLIWRATH
	dw_const CeladonCityRocket1Text,           TEXT_CELADONCITY_ROCKET1
	dw_const CeladonCityRocket2Text,           TEXT_CELADONCITY_ROCKET2
	dw_const CeladonCityTrainerTips1Text,      TEXT_CELADONCITY_TRAINER_TIPS1
	dw_const CeladonCitySignText,              TEXT_CELADONCITY_SIGN
	dw_const PokeCenterSignText,               TEXT_CELADONCITY_POKECENTER_SIGN
	dw_const CeladonCityGymSignText,           TEXT_CELADONCITY_GYM_SIGN
	dw_const CeladonCityMansionSignText,       TEXT_CELADONCITY_MANSION_SIGN
	dw_const CeladonCityDeptStoreSignText,     TEXT_CELADONCITY_DEPTSTORE_SIGN
	dw_const CeladonCityTrainerTips2Text,      TEXT_CELADONCITY_TRAINER_TIPS2
	dw_const CeladonCityPrizeExchangeSignText, TEXT_CELADONCITY_PRIZEEXCHANGE_SIGN
	dw_const CeladonCityGameCornerSignText,    TEXT_CELADONCITY_GAMECORNER_SIGN

CeladonCityLittleGirlText:
	text_far WLA_GLOBAL_CeladonCityLittleGirlText
	text_end

CeladonCityGramps1Text:
	text_far WLA_GLOBAL_CeladonCityGramps1Text
	text_end

CeladonCityGirlText:
	text_far WLA_GLOBAL_CeladonCityGirlText
	text_end

CeladonCityGramps2Text:
	text_far WLA_GLOBAL_CeladonCityGramps2Text
	text_end

CeladonCityGramps3Text:
	text_asm
	CheckEvent EVENT_GOT_TM41
	jr nz, CeladonCityGramps3Text.gotTM41
	ld hl, CeladonCityGramps3Text.Text
	call PrintText
	lb "bc", TM_SOFTBOILED, 1
	call GiveItem
	jr c, CeladonCityGramps3Text.Success
	ld hl, CeladonCityGramps3Text.TM41NoRoomText
	call PrintText
	jr CeladonCityGramps3Text.Done
CeladonCityGramps3Text.Success
	ld hl, CeladonCityGramps3Text.ReceivedTM41Text
	call PrintText
	SetEvent EVENT_GOT_TM41
	jr CeladonCityGramps3Text.Done
CeladonCityGramps3Text.gotTM41
	ld hl, CeladonCityGramps3Text.TM41ExplanationText
	call PrintText
CeladonCityGramps3Text.Done
	jp TextScriptEnd

CeladonCityGramps3Text.Text:
	text_far WLA_GLOBAL_CeladonCityGramps3Text
	text_end

CeladonCityGramps3Text.ReceivedTM41Text:
	text_far WLA_GLOBAL_CeladonCityGramps3ReceivedTM41Text
	sound_get_item_1
	text_end

CeladonCityGramps3Text.TM41ExplanationText:
	text_far WLA_GLOBAL_CeladonCityGramps3TM41ExplanationText
	text_end

CeladonCityGramps3Text.TM41NoRoomText:
	text_far WLA_GLOBAL_CeladonCityGramps3TM41NoRoomText
	text_end

CeladonCityFisherText:
	text_far WLA_GLOBAL_CeladonCityFisherText
	text_end

CeladonCityPoliwrathText:
	text_far WLA_GLOBAL_CeladonCityPoliwrathText
	text_asm
	ld a, POLIWRATH
	call PlayCry
	jp TextScriptEnd

CeladonCityRocket1Text:
	text_far WLA_GLOBAL_CeladonCityRocket1Text
	text_end

CeladonCityRocket2Text:
	text_far WLA_GLOBAL_CeladonCityRocket2Text
	text_end

CeladonCityTrainerTips1Text:
	text_far WLA_GLOBAL_CeladonCityTrainerTips1Text
	text_end

CeladonCitySignText:
	text_far WLA_GLOBAL_CeladonCitySignText
	text_end

CeladonCityGymSignText:
	text_far WLA_GLOBAL_CeladonCityGymSignText
	text_end

CeladonCityMansionSignText:
	text_far WLA_GLOBAL_CeladonCityMansionSignText
	text_end

CeladonCityDeptStoreSignText:
	text_far WLA_GLOBAL_CeladonCityDeptStoreSignText
	text_end

CeladonCityTrainerTips2Text:
	text_far WLA_GLOBAL_CeladonCityTrainerTips2Text
	text_end

CeladonCityPrizeExchangeSignText:
	text_far WLA_GLOBAL_CeladonCityPrizeExchangeSignText
	text_end

CeladonCityGameCornerSignText:
	text_far WLA_GLOBAL_CeladonCityGameCornerSignText
	text_end
