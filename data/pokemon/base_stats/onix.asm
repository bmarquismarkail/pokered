	.DB DEX_ONIX ; pokedex id

	.DB  35,  45, 160,  70,  30
	;   hp  atk  def  spd  spc

	.DB ROCK, GROUND ; type
	.DB 45 ; catch rate
	.DB 108 ; base exp

	.INCBIN "gfx/pokemon/front/onix.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW OnixPicFront, OnixPicBack

	.DB TACKLE, SCREECH, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         SELFDESTRUCT, SKULL_BASH,   REST,         EXPLOSION,    \
	     ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
