	.DB DEX_WARTORTLE ; pokedex id

	.DB  59,  63,  80,  58,  65
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 45 ; catch rate
	.DB 143 ; base exp

	.INCBIN "gfx/pokemon/front/wartortle.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW WartortlePicFront, WartortlePicBack

	.DB TACKLE, TAIL_WHIP, BUBBLE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         DIG,          \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SKULL_BASH,   \
	     REST,         SUBSTITUTE,   SURF,         STRENGTH
	; end

	.DB 0 ; padding
