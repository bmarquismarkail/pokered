	.DB DEX_WEEZING ; pokedex id

	.DB  65,  90, 120,  60,  85
	;   hp  atk  def  spd  spc

	.DB POISON, POISON ; type
	.DB 60 ; catch rate
	.DB 173 ; base exp

	.INCBIN "gfx/pokemon/front/weezing.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW WeezingPicFront, WeezingPicBack

	.DB TACKLE, SMOG, SLUDGE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HYPER_BEAM,   RAGE,         THUNDERBOLT,  THUNDER,      \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SELFDESTRUCT, FIRE_BLAST,   \
	     REST,         EXPLOSION,    SUBSTITUTE
	; end

	.DB 0 ; padding
