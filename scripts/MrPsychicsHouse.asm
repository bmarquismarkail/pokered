MrPsychicsHouse_Script:
	jp EnableAutoTextBoxDrawing

MrPsychicsHouse_TextPointers:
	def_text_pointers
	dw_const MrPsychicsHouseMrPsychicText, TEXT_MRPSYCHICSHOUSE_MR_PSYCHIC

MrPsychicsHouseMrPsychicText:
	text_asm
	CheckEvent EVENT_GOT_TM29
	jr nz, MrPsychicsHouseMrPsychicText.got_item
	ld hl, MrPsychicsHouseMrPsychicText.YouWantedThisText
	call PrintText
	lb "bc", TM_PSYCHIC_M, 1
	call GiveItem
	jr nc, MrPsychicsHouseMrPsychicText.bag_full
	ld hl, MrPsychicsHouseMrPsychicText.ReceivedTM29Text
	call PrintText
	SetEvent EVENT_GOT_TM29
	jr MrPsychicsHouseMrPsychicText.done
MrPsychicsHouseMrPsychicText.bag_full
	ld hl, MrPsychicsHouseMrPsychicText.TM29NoRoomText
	call PrintText
	jr MrPsychicsHouseMrPsychicText.done
MrPsychicsHouseMrPsychicText.got_item
	ld hl, MrPsychicsHouseMrPsychicText.TM29ExplanationText
	call PrintText
MrPsychicsHouseMrPsychicText.done
	jp TextScriptEnd

MrPsychicsHouseMrPsychicText.YouWantedThisText:
	text_far WLA_GLOBAL_MrPsychicsHouseMrPsychicYouWantedThisText
	text_end

MrPsychicsHouseMrPsychicText.ReceivedTM29Text:
	text_far WLA_GLOBAL_MrPsychicsHouseMrPsychicReceivedTM29Text
	sound_get_item_1
	text_end

MrPsychicsHouseMrPsychicText.TM29ExplanationText:
	text_far WLA_GLOBAL_MrPsychicsHouseMrPsychicTM29ExplanationText
	text_end

MrPsychicsHouseMrPsychicText.TM29NoRoomText:
	text_far WLA_GLOBAL_MrPsychicsHouseMrPsychicTM29NoRoomText
	text_end
