Route11Gate2F_Script:
	jp DisableAutoTextBoxDrawing

Route11Gate2F_TextPointers:
	def_text_pointers
	dw_const Route11Gate2FYoungsterText,       TEXT_ROUTE11GATE2F_YOUNGSTER
	dw_const Route11Gate2FOaksAideText,        TEXT_ROUTE11GATE2F_OAKS_AIDE
	dw_const Route11Gate2FLeftBinocularsText,  TEXT_ROUTE11GATE2F_LEFT_BINOCULARS
	dw_const Route11Gate2FRightBinocularsText, TEXT_ROUTE11GATE2F_RIGHT_BINOCULARS

Route11Gate2FYoungsterText:
	text_asm
	xor a ; TRADE_FOR_TERRY
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
Route11Gate2FScriptEnd:
	jp TextScriptEnd

Route11Gate2FOaksAideText:
	text_asm
	CheckEvent EVENT_GOT_ITEMFINDER, 1
	jr c, Route11Gate2FOaksAideText.got_item
	ld a, 30
	ldh [lobyte(hOaksAideRequirement)], a
	ld a, ITEMFINDER
	ldh [lobyte(hOaksAideRewardItem)], a
	ld [wNamedObjectIndex], a
	call GetItemName
	ld h, d
	ld l, e
	ld de, wOaksAideRewardItemName
	ld bc, ITEM_NAME_LENGTH
	call CopyData
	predef OaksAideScript
	ldh a, [lobyte(hOaksAideResult)]
	dec a ; OAKS_AIDE_GOT_ITEM?
	jr nz, Route11Gate2FOaksAideText.no_item
	SetEvent EVENT_GOT_ITEMFINDER
Route11Gate2FOaksAideText.got_item
	ld hl, Route11Gate2FOaksAideText.ItemfinderDescriptionText
	call PrintText
Route11Gate2FOaksAideText.no_item
	jr Route11Gate2FScriptEnd

Route11Gate2FOaksAideText.ItemfinderDescriptionText:
	text_far WLA_GLOBAL_Route11Gate2FOaksAideItemfinderDescriptionText
	text_end

Route11Gate2FLeftBinocularsText:
	text_asm
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jp nz, GateUpstairsScript_PrintIfFacingUp
	CheckEvent EVENT_BEAT_ROUTE12_SNORLAX
	ld hl, Route11Gate2FLeftBinocularsText.SnorlaxText
	jr z, Route11Gate2FLeftBinocularsText.print
	ld hl, Route11Gate2FLeftBinocularsText.NoSnorlaxText
Route11Gate2FLeftBinocularsText.print
	call PrintText
	jp TextScriptEnd

Route11Gate2FLeftBinocularsText.SnorlaxText:
	text_far WLA_GLOBAL_Route11Gate2FLeftBinocularsSnorlaxText
	text_end

Route11Gate2FLeftBinocularsText.NoSnorlaxText:
	text_far WLA_GLOBAL_Route11Gate2FLeftBinocularsNoSnorlaxText
	text_end

Route11Gate2FRightBinocularsText:
	text_asm
	ld hl, Route11Gate2FRightBinocularsText.Text
	jp GateUpstairsScript_PrintIfFacingUp

Route11Gate2FRightBinocularsText.Text:
	text_far WLA_GLOBAL_Route11Gate2FRightBinocularsText
	text_end
