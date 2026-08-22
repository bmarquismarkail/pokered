	.DB DEX_MAROWAK ; pokedex id

	.DB  60,  80, 110,  45,  50
	;   hp  atk  def  spd  spc

	.DB GROUND, GROUND ; type
	.DB 75 ; catch rate
	.DB 124 ; base exp

	.INCBIN "gfx/pokemon/front/marowak.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MarowakPicFront, MarowakPicBack

	.DB BONE_CLUB, GROWL, LEER, FOCUS_ENERGY ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         FIRE_BLAST,   SKULL_BASH,   REST,         SUBSTITUTE,   \
	     STRENGTH
	; end

	.DB 0 ; padding
