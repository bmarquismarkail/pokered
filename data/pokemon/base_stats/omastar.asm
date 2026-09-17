	.DB DEX_OMASTAR ; pokedex id

	.DB  70,  60, 125,  55, 115
	;   hp  atk  def  spd  spc

	.DB ROCK, WATER ; type
	.DB 45 ; catch rate
	.DB 199 ; base exp

	.INCBIN "gfx/pokemon/front/omastar.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW OmastarPicFront, OmastarPicBack

	.DB WATER_GUN, WITHDRAW, HORN_ATTACK, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   \
	     SUBMISSION,   SEISMIC_TOSS, RAGE,         MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         SKULL_BASH,   REST,         SUBSTITUTE,   \
	     SURF
	; end

	.DB 0 ; padding
