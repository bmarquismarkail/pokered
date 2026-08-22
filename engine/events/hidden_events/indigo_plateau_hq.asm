PrintIndigoPlateauHQText:
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	tx_pre_jump IndigoPlateauHQText

IndigoPlateauHQText:
	text_far WLA_GLOBAL_IndigoPlateauHQText
	text_end
