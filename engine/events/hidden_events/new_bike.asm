PrintNewBikeText:
	call EnableAutoTextBoxDrawing
	tx_pre_jump NewBicycleText

NewBicycleText:
	text_far WLA_GLOBAL_NewBicycleText
	text_end
