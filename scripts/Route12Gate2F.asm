Route12Gate2F_Script:
	jp DisableAutoTextBoxDrawing

Route12Gate2F_TextPointers:
	def_text_pointers
	dw_const Route12Gate2FBrunetteGirlText,    TEXT_ROUTE12GATE2F_BRUNETTE_GIRL
	dw_const Route12Gate2FLeftBinocularsText,  TEXT_ROUTE12GATE2F_LEFT_BINOCULARS
	dw_const Route12Gate2FRightBinocularsText, TEXT_ROUTE12GATE2F_RIGHT_BINOCULARS

Route12Gate2FBrunetteGirlText:
	text_asm
	CheckEvent EVENT_GOT_TM39, 1
	jr c, Route12Gate2FBrunetteGirlText.got_item
	ld hl, Route12Gate2FBrunetteGirlText.YouCanHaveThisText
	call PrintText
	lb "bc", TM_SWIFT, 1
	call GiveItem
	jr nc, Route12Gate2FBrunetteGirlText.bag_full
	ld hl, Route12Gate2FBrunetteGirlText.ReceivedTM39Text
	call PrintText
	SetEvent EVENT_GOT_TM39
	jr Route12Gate2FBrunetteGirlText.done
Route12Gate2FBrunetteGirlText.bag_full
	ld hl, Route12Gate2FBrunetteGirlText.TM39NoRoomText
	call PrintText
	jr Route12Gate2FBrunetteGirlText.done
Route12Gate2FBrunetteGirlText.got_item
	ld hl, Route12Gate2FBrunetteGirlText.TM39ExplanationText
	call PrintText
Route12Gate2FBrunetteGirlText.done
	jp TextScriptEnd

Route12Gate2FBrunetteGirlText.YouCanHaveThisText:
	text_far WLA_GLOBAL_Route12Gate2FBrunetteGirlYouCanHaveThisText
	text_end

Route12Gate2FBrunetteGirlText.ReceivedTM39Text:
	text_far WLA_GLOBAL_Route12Gate2FBrunetteGirlReceivedTM39Text
	sound_get_item_1
	text_end

Route12Gate2FBrunetteGirlText.TM39ExplanationText:
	text_far WLA_GLOBAL_Route12Gate2FBrunetteGirlTM39ExplanationText
	text_end

Route12Gate2FBrunetteGirlText.TM39NoRoomText:
	text_far WLA_GLOBAL_Route12Gate2FBrunetteGirlTM39NoRoomText
	text_end

Route12Gate2FLeftBinocularsText:
	text_asm
	ld hl, Route12Gate2FLeftBinocularsText.Text
	jp GateUpstairsScript_PrintIfFacingUp

Route12Gate2FLeftBinocularsText.Text:
	text_far WLA_GLOBAL_Route12Gate2FLeftBinocularsText
	text_end

Route12Gate2FRightBinocularsText:
	text_asm
	ld hl, Route12Gate2FRightBinocularsText.Text
	jp GateUpstairsScript_PrintIfFacingUp

Route12Gate2FRightBinocularsText.Text:
	text_far WLA_GLOBAL_Route12Gate2FRightBinocularsText
	text_end

GateUpstairsScript_PrintIfFacingUp:
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jr z, GateUpstairsScript_PrintIfFacingUp.up
	ld a, TRUE
	jr GateUpstairsScript_PrintIfFacingUp.done
GateUpstairsScript_PrintIfFacingUp.up
	call PrintText
	xor a
GateUpstairsScript_PrintIfFacingUp.done
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd
