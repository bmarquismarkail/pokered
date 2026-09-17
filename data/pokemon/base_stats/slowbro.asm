	.DB DEX_SLOWBRO ; pokedex id

	.DB  95,  75, 110,  30,  80
	;   hp  atk  def  spd  spc

	.DB WATER, PSYCHIC_TYPE ; type
	.DB 75 ; catch rate
	.DB 164 ; base exp

	.INCBIN "gfx/pokemon/front/slowbro.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW SlowbroPicFront, SlowbroPicBack

	.DB CONFUSION, DISABLE, HEADBUTT, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   PAY_DAY,      SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         EARTHQUAKE,   FISSURE,      DIG,          PSYCHIC_M,    \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     FIRE_BLAST,   SWIFT,        SKULL_BASH,   REST,         THUNDER_WAVE, \
	     PSYWAVE,      TRI_ATTACK,   SUBSTITUTE,   SURF,         STRENGTH,     \
	     FLASH
	; end

	.DB 0 ; padding
