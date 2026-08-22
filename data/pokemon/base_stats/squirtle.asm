	.DB DEX_SQUIRTLE ; pokedex id

	.DB  44,  48,  65,  43,  50
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 45 ; catch rate
	.DB 66 ; base exp

	.INCBIN "gfx/pokemon/front/squirtle.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW SquirtlePicFront, SquirtlePicBack

	.DB TACKLE, TAIL_WHIP, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         DIG,          \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SKULL_BASH,   \
	     REST,         SUBSTITUTE,   SURF,         STRENGTH
	; end

	.DB 0 ; padding
