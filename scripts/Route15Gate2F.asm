Route15Gate2F_Script:
	jp DisableAutoTextBoxDrawing

Route15Gate2F_TextPointers:
	def_text_pointers
	dw_const Route15Gate2FOaksAideText,   TEXT_ROUTE15GATE2F_OAKS_AIDE
	dw_const Route15Gate2FBinocularsText, TEXT_ROUTE15GATE2F_BINOCULARS

Route15Gate2FOaksAideText:
	text_asm
	CheckEvent EVENT_GOT_EXP_ALL
	jr nz, Route15Gate2FOaksAideText.got_item
	ld a, 50
	ldh [lobyte(hOaksAideRequirement)], a
	ld a, EXP_ALL
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
	jr nz, Route15Gate2FOaksAideText.no_item
	SetEvent EVENT_GOT_EXP_ALL
Route15Gate2FOaksAideText.got_item
	ld hl, Route15Gate2FOaksAideText.ExpAllText
	call PrintText
Route15Gate2FOaksAideText.no_item
	jp TextScriptEnd

Route15Gate2FOaksAideText.ExpAllText:
	text_far WLA_GLOBAL_Route15Gate2FOaksAideExpAllText
	text_end

Route15Gate2FBinocularsText:
	text_asm
	ld hl, Route15Gate2FBinocularsText.Text
	jp GateUpstairsScript_PrintIfFacingUp

Route15Gate2FBinocularsText.Text:
	text_far WLA_GLOBAL_Route15Gate2FBinocularsText
	text_end
