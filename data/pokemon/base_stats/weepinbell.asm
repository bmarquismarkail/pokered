	.DB DEX_WEEPINBELL ; pokedex id

	.DB  65,  90,  50,  55,  85
	;   hp  atk  def  spd  spc

	.DB GRASS, POISON ; type
	.DB 120 ; catch rate
	.DB 151 ; base exp

	.INCBIN "gfx/pokemon/front/weepinbell.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW WeepinbellPicFront, WeepinbellPicBack

	.DB VINE_WHIP, GROWTH, WRAP, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         REST,         SUBSTITUTE,   CUT
	; end

	.DB 0 ; padding
