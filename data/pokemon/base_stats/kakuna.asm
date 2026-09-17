	.DB DEX_KAKUNA ; pokedex id

	.DB  45,  25,  50,  35,  25
	;   hp  atk  def  spd  spc

	.DB BUG, POISON ; type
	.DB 120 ; catch rate
	.DB 71 ; base exp

	.INCBIN "gfx/pokemon/front/kakuna.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW KakunaPicFront, KakunaPicBack

	.DB HARDEN, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	.DB 0 ; padding
