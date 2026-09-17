TextScriptEndingText:
	text_end

TextScriptEnd:
	ld hl, TextScriptEndingText
	ret

ExclamationText:
	text_far WLA_GLOBAL_ExclamationText
	text_end

GroundRoseText:
	text_far WLA_GLOBAL_GroundRoseText
	text_end

BoulderText:
	text_far WLA_GLOBAL_BoulderText
	text_end

MartSignText:
	text_far WLA_GLOBAL_MartSignText
	text_end

PokeCenterSignText:
	text_far WLA_GLOBAL_PokeCenterSignText
	text_end

PickUpItemText:
	text_asm
	predef PickUpItem
	jp TextScriptEnd
