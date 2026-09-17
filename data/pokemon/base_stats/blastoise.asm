	.DB DEX_BLASTOISE ; pokedex id

	.DB  79,  83, 100,  78,  85
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 45 ; catch rate
	.DB 210 ; base exp

	.INCBIN "gfx/pokemon/front/blastoise.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW BlastoisePicFront, BlastoisePicBack

	.DB TACKLE, TAIL_WHIP, BUBBLE, WATER_GUN ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         SKULL_BASH,   REST,         SUBSTITUTE,   \
	     SURF,         STRENGTH
	; end

	.DB 0 ; padding
