
	ret ; unused

UnusedPredefText:
		.STRINGMAP pokemon, "@"

PrintBookcaseText:
	call EnableAutoTextBoxDrawing
	tx_pre_jump BookcaseText

BookcaseText:
	text_far WLA_GLOBAL_BookcaseText
	text_end
