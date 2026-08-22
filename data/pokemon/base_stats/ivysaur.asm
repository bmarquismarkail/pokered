	.DB DEX_IVYSAUR ; pokedex id

	.DB  60,  62,  63,  60,  80
	;   hp  atk  def  spd  spc

	.DB GRASS, POISON ; type
	.DB 45 ; catch rate
	.DB 141 ; base exp

	.INCBIN "gfx/pokemon/front/ivysaur.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW IvysaurPicFront, IvysaurPicBack

	.DB TACKLE, GROWL, LEECH_SEED, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         REST,         SUBSTITUTE,   CUT
	; end

	.DB 0 ; padding
