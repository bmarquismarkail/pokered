PewterMart_Script:
	call EnableAutoTextBoxDrawing
	ld a, 1 << BIT_NO_AUTO_TEXT_BOX
	ld [wAutoTextBoxDrawingControl], a
	ret

PewterMart_TextPointers:
	def_text_pointers
	dw_const PewterMartClerkText,     TEXT_PEWTERMART_CLERK
	dw_const PewterMartYoungsterText, TEXT_PEWTERMART_YOUNGSTER
	dw_const PewterMartSuperNerdText, TEXT_PEWTERMART_SUPER_NERD

PewterMartYoungsterText:
	text_asm
	ld hl, PewterMartYoungsterText.Text
	call PrintText
	jp TextScriptEnd

PewterMartYoungsterText.Text:
	text_far WLA_GLOBAL_PewterMartYoungsterText
	text_end

PewterMartSuperNerdText:
	text_asm
	ld hl, PewterMartSuperNerdText.Text
	call PrintText
	jp TextScriptEnd

PewterMartSuperNerdText.Text:
	text_far WLA_GLOBAL_PewterMartSuperNerdText
	text_end
