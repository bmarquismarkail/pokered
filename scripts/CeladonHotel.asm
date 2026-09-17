CeladonHotel_Script:
	jp EnableAutoTextBoxDrawing

CeladonHotel_TextPointers:
	def_text_pointers
	dw_const CeladonHotelGrannyText,    TEXT_CELADONHOTEL_GRANNY
	dw_const CeladonHotelBeautyText,    TEXT_CELADONHOTEL_BEAUTY
	dw_const CeladonHotelSuperNerdText, TEXT_CELADONHOTEL_SUPER_NERD

CeladonHotelGrannyText:
	text_far WLA_GLOBAL_CeladonHotelGrannyText
	text_end

CeladonHotelBeautyText:
	text_far WLA_GLOBAL_CeladonHotelBeautyText
	text_end

CeladonHotelSuperNerdText:
	text_far WLA_GLOBAL_CeladonHotelSuperNerdText
	text_end
