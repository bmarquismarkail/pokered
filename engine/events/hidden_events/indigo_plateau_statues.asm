IndigoPlateauStatues:
	text_asm
	ld hl, IndigoPlateauStatuesText1
	call PrintText
	ld a, [wXCoord]
	bit 0, a ; even or odd?
	ld hl, IndigoPlateauStatuesText2
	jr nz, IndigoPlateauStatues.ok
	ld hl, IndigoPlateauStatuesText3
IndigoPlateauStatues.ok
	call PrintText
	jp TextScriptEnd

IndigoPlateauStatuesText1:
	text_far WLA_GLOBAL_IndigoPlateauStatuesText1
	text_end

IndigoPlateauStatuesText2:
	text_far WLA_GLOBAL_IndigoPlateauStatuesText2
	text_end

IndigoPlateauStatuesText3:
	text_far WLA_GLOBAL_IndigoPlateauStatuesText3
	text_end
