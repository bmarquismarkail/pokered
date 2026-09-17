	.DB DEX_POLIWAG ; pokedex id

	.DB  40,  50,  40,  90,  40
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 255 ; catch rate
	.DB 77 ; base exp

	.INCBIN "gfx/pokemon/front/poliwag.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PoliwagPicFront, PoliwagPicBack

	.DB BUBBLE, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         PSYCHIC_M,    \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SKULL_BASH,   REST,         \
	     PSYWAVE,      SUBSTITUTE,   SURF
	; end

	.DB 0 ; padding
