	.DB DEX_POLIWRATH ; pokedex id

	.DB  90,  85,  95,  70,  70
	;   hp  atk  def  spd  spc

	.DB WATER, FIGHTING ; type
	.DB 45 ; catch rate
	.DB 185 ; base exp

	.INCBIN "gfx/pokemon/front/poliwrath.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PoliwrathPicFront, PoliwrathPicBack

	.DB HYPNOSIS, WATER_GUN, DOUBLESLAP, BODY_SLAM ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     EARTHQUAKE,   FISSURE,      PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         METRONOME,    SKULL_BASH,   REST,         PSYWAVE,      \
	     SUBSTITUTE,   SURF,         STRENGTH
	; end

	.DB 0 ; padding
