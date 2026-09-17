	.DB DEX_CUBONE ; pokedex id

	.DB  50,  50,  95,  35,  40
	;   hp  atk  def  spd  spc

	.DB GROUND, GROUND ; type
	.DB 190 ; catch rate
	.DB 87 ; base exp

	.INCBIN "gfx/pokemon/front/cubone.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW CubonePicFront, CubonePicBack

	.DB BONE_CLUB, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         EARTHQUAKE,   \
	     FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     FIRE_BLAST,   SKULL_BASH,   REST,         SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
