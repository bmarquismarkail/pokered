DisplayEffectiveness:
	ld a, [wDamageMultipliers]
	and $7F
	cp EFFECTIVE
	ret z
	ld hl, SuperEffectiveText
	jr nc, DisplayEffectiveness.done
	ld hl, NotVeryEffectiveText
DisplayEffectiveness.done
	jp PrintText

SuperEffectiveText:
	text_far WLA_GLOBAL_SuperEffectiveText
	text_end

NotVeryEffectiveText:
	text_far WLA_GLOBAL_NotVeryEffectiveText
	text_end
