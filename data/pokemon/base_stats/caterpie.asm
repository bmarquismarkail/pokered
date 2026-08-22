	.DB DEX_CATERPIE ; pokedex id

	.DB  45,  30,  35,  45,  20
	;   hp  atk  def  spd  spc

	.DB BUG, BUG ; type
	.DB 255 ; catch rate
	.DB 53 ; base exp

	.INCBIN "gfx/pokemon/front/caterpie.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW CaterpiePicFront, CaterpiePicBack

	.DB TACKLE, STRING_SHOT, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	.DB 0 ; padding
