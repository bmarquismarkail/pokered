	.DB DEX_HYPNO ; pokedex id

	.DB  85,  73,  70,  67, 115
	;   hp  atk  def  spd  spc

	.DB PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	.DB 75 ; catch rate
	.DB 165 ; base exp

	.INCBIN "gfx/pokemon/front/hypno.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW HypnoPicFront, HypnoPicBack

	.DB POUND, HYPNOSIS, DISABLE, CONFUSION ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         PSYCHIC_M,    TELEPORT,     MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         METRONOME,    SKULL_BASH,   DREAM_EATER,  \
	     REST,         THUNDER_WAVE, PSYWAVE,      TRI_ATTACK,   SUBSTITUTE,   \
	     FLASH
	; end

	.DB 0 ; padding
