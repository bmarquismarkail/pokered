	.DB DEX_VENUSAUR ; pokedex id

	.DB  80,  82,  83,  80, 100
	;   hp  atk  def  spd  spc

	.DB GRASS, POISON ; type
	.DB 45 ; catch rate
	.DB 208 ; base exp

	.INCBIN "gfx/pokemon/front/venusaur.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW VenusaurPicFront, VenusaurPicBack

	.DB TACKLE, GROWL, LEECH_SEED, VINE_WHIP ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         REST,         SUBSTITUTE,   \
	     CUT
	; end

	.DB 0 ; padding
