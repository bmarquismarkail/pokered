	.DB DEX_DITTO ; pokedex id

	.DB  48,  48,  48,  48,  48
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 35 ; catch rate
	.DB 61 ; base exp

	.INCBIN "gfx/pokemon/front/ditto.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW DittoPicFront, DittoPicBack

	.DB TRANSFORM, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	.DB 0 ; padding
