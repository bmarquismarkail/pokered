	.DB DEX_METAPOD ; pokedex id

	.DB  50,  20,  55,  30,  25
	;   hp  atk  def  spd  spc

	.DB BUG, BUG ; type
	.DB 120 ; catch rate
	.DB 72 ; base exp

	.INCBIN "gfx/pokemon/front/metapod.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MetapodPicFront, MetapodPicBack

	.DB HARDEN, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	.DB 0 ; padding
