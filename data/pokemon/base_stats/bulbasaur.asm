	.DB DEX_BULBASAUR ; pokedex id

	.DB  45,  49,  49,  45,  65
	;   hp  atk  def  spd  spc

	.DB GRASS, POISON ; type
	.DB 45 ; catch rate
	.DB 64 ; base exp

	.INCBIN "gfx/pokemon/front/bulbasaur.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW BulbasaurPicFront, BulbasaurPicBack

	.DB TACKLE, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         REST,         SUBSTITUTE,   CUT
	; end

	.DB 0 ; padding
