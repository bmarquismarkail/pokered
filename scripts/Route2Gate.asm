Route2Gate_Script:
	jp EnableAutoTextBoxDrawing

Route2Gate_TextPointers:
	def_text_pointers
	dw_const Route2GateOaksAideText,  TEXT_ROUTE2GATE_OAKS_AIDE
	dw_const Route2GateYoungsterText, TEXT_ROUTE2GATE_YOUNGSTER

Route2GateOaksAideText:
	text_asm
	CheckEvent EVENT_GOT_HM05
	jr nz, Route2GateOaksAideText.got_item
	ld a, 10
	ldh [lobyte(hOaksAideRequirement)], a
	ld a, HM_FLASH
	ldh [lobyte(hOaksAideRewardItem)], a
	ld [wNamedObjectIndex], a
	call GetItemName
	ld hl, wNameBuffer
	ld de, wOaksAideRewardItemName
	ld bc, ITEM_NAME_LENGTH
	call CopyData
	predef OaksAideScript
	ldh a, [lobyte(hOaksAideResult)]
	cp OAKS_AIDE_GOT_ITEM
	jr nz, Route2GateOaksAideText.no_item
	SetEvent EVENT_GOT_HM05
Route2GateOaksAideText.got_item
	ld hl, Route2GateOaksAideText.FlashExplanationText
	call PrintText
Route2GateOaksAideText.no_item
	jp TextScriptEnd

Route2GateOaksAideText.FlashExplanationText:
	text_far WLA_GLOBAL_Route2GateOaksAideFlashExplanationText
	text_end

Route2GateYoungsterText:
	text_far WLA_GLOBAL_Route2GateYoungsterText
	text_end
