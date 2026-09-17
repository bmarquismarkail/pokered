	.DB DEX_NIDOQUEEN ; pokedex id

	.DB  90,  82,  87,  76,  75
	;   hp  atk  def  spd  spc

	.DB POISON, GROUND ; type
	.DB 45 ; catch rate
	.DB 194 ; base exp

	.INCBIN "gfx/pokemon/front/nidoqueen.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW NidoqueenPicFront, NidoqueenPicBack

	.DB TACKLE, SCRATCH, TAIL_WHIP, BODY_SLAM ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        HORN_DRILL,   BODY_SLAM,    \
	     TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     \
	     BLIZZARD,     HYPER_BEAM,   PAY_DAY,      SUBMISSION,   COUNTER,      \
	     SEISMIC_TOSS, RAGE,         THUNDERBOLT,  THUNDER,      EARTHQUAKE,   \
	     FISSURE,      MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     FIRE_BLAST,   SKULL_BASH,   REST,         ROCK_SLIDE,   SUBSTITUTE,   \
	     SURF,         STRENGTH
	; end

	.DB 0 ; padding
