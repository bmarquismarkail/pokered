	.DB DEX_MAGIKARP ; pokedex id

	.DB  20,  10,  55,  80,  20
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 255 ; catch rate
	.DB 20 ; base exp

	.INCBIN "gfx/pokemon/front/magikarp.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MagikarpPicFront, MagikarpPicBack

	.DB SPLASH, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm
	; end

	.DB 0 ; padding
