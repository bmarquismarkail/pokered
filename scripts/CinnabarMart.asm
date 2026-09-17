CinnabarMart_Script:
	jp EnableAutoTextBoxDrawing

CinnabarMart_TextPointers:
	def_text_pointers
	dw_const CinnabarMartClerkText,        TEXT_CINNABARMART_CLERK
	dw_const CinnabarMartSilphWorkerFText, TEXT_CINNABARMART_SILPH_WORKER_F
	dw_const CinnabarMartScientistText,    TEXT_CINNABARMART_SCIENTIST

CinnabarMartSilphWorkerFText:
	text_far WLA_GLOBAL_CinnabarMartSilphWorkerFText
	text_end

CinnabarMartScientistText:
	text_far WLA_GLOBAL_CinnabarMartScientistText
	text_end
