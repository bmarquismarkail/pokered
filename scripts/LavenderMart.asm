LavenderMart_Script:
	jp EnableAutoTextBoxDrawing

LavenderMart_TextPointers:
	def_text_pointers
	dw_const LavenderMartClerkText,        TEXT_LAVENDERMART_CLERK
	dw_const LavenderMartBaldingGuyText,   TEXT_LAVENDERMART_BALDING_GUY
	dw_const LavenderMartCooltrainerMText, TEXT_LAVENDERMART_COOLTRAINER_M

LavenderMartBaldingGuyText:
	text_far WLA_GLOBAL_LavenderMartBaldingGuyText
	text_end

LavenderMartCooltrainerMText:
	text_asm
	CheckEvent EVENT_RESCUED_MR_FUJI
	jr nz, LavenderMartCooltrainerMText.Nugget
	ld hl, LavenderMartCooltrainerMText.ReviveText
	call PrintText
	jr LavenderMartCooltrainerMText.done
LavenderMartCooltrainerMText.Nugget
	ld hl, LavenderMartCooltrainerMText.NuggetText
	call PrintText
LavenderMartCooltrainerMText.done
	jp TextScriptEnd

LavenderMartCooltrainerMText.ReviveText
	text_far WLA_GLOBAL_LavenderMartCooltrainerMReviveText
	text_end

LavenderMartCooltrainerMText.NuggetText
	text_far WLA_GLOBAL_LavenderMartCooltrainerMNuggetText
	text_end
