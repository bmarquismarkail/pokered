	.DB DEX_WIGGLYTUFF ; pokedex id

	.DB 140,  70,  45,  45,  50
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 50 ; catch rate
	.DB 109 ; base exp

	.INCBIN "gfx/pokemon/front/wigglytuff.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW WigglytuffPicFront, WigglytuffPicBack

	.DB SING, DISABLE, DEFENSE_CURL, DOUBLESLAP ; level 1 learnset
	.DB GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     SOLARBEAM,    THUNDERBOLT,  THUNDER,      PSYCHIC_M,    TELEPORT,     \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         FIRE_BLAST,   \
	     SKULL_BASH,   REST,         THUNDER_WAVE, PSYWAVE,      TRI_ATTACK,   \
	     SUBSTITUTE,   STRENGTH,     FLASH
	; end

	.DB 0 ; padding
