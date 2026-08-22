PrintMagazinesText:
	call EnableAutoTextBoxDrawing
	tx_pre MagazinesText
	ret

MagazinesText:
	text_far WLA_GLOBAL_MagazinesText
	text_end
