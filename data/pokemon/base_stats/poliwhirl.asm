	.DB DEX_POLIWHIRL ; pokedex id

	.DB  65,  65,  65,  90,  50
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 120 ; catch rate
	.DB 131 ; base exp

	.INCBIN "gfx/pokemon/front/poliwhirl.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PoliwhirlPicFront, PoliwhirlPicBack

	.DB BUBBLE, HYPNOSIS, WATER_GUN, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         EARTHQUAKE,   \
	     FISSURE,      PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     METRONOME,    SKULL_BASH,   REST,         PSYWAVE,      SUBSTITUTE,   \
	     SURF,         STRENGTH
	; end

	.DB 0 ; padding
