SaffronMart_Script:
	jp EnableAutoTextBoxDrawing

SaffronMart_TextPointers:
	def_text_pointers
	dw_const SaffronMartClerkText,        TEXT_SAFFRONMART_CLERK
	dw_const SaffronMartSuperNerdText,    TEXT_SAFFRONMART_SUPER_NERD
	dw_const SaffronMartCooltrainerFText, TEXT_SAFFRONMART_COOLTRAINER_F

SaffronMartSuperNerdText:
	text_far WLA_GLOBAL_SaffronMartSuperNerdText
	text_end

SaffronMartCooltrainerFText:
	text_far WLA_GLOBAL_SaffronMartCooltrainerFText
	text_end
