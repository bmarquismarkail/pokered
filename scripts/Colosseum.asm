Colosseum_Script:
	; Both link-room maps expose their opponent as object 1. The linked symbol
	; audit verifies that invariant; WLA cannot resolve this cross-section
	; assertion while assembling maps.asm.
	jp TradeCenter_Script

Colosseum_TextPointers:
	def_text_pointers
	dw_const ColosseumOpponentText, TEXT_COLOSSEUM_OPPONENT

ColosseumOpponentText:
	text_far WLA_GLOBAL_ColosseumOpponentText
	text_end
