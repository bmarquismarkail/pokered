	.DB DEX_WEEDLE ; pokedex id

	.DB  40,  35,  30,  50,  20
	;   hp  atk  def  spd  spc

	.DB BUG, POISON ; type
	.DB 255 ; catch rate
	.DB 52 ; base exp

	.INCBIN "gfx/pokemon/front/weedle.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW WeedlePicFront, WeedlePicBack

	.DB POISON_STING, STRING_SHOT, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	.DB 0 ; padding
