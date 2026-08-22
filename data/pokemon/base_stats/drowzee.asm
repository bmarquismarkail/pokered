	.DB DEX_DROWZEE ; pokedex id

	.DB  60,  48,  45,  42,  90
	;   hp  atk  def  spd  spc

	.DB PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	.DB 190 ; catch rate
	.DB 102 ; base exp

	.INCBIN "gfx/pokemon/front/drowzee.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW DrowzeePicFront, DrowzeePicBack

	.DB POUND, HYPNOSIS, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     PSYCHIC_M,    TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         METRONOME,    SKULL_BASH,   DREAM_EATER,  REST,         \
	     THUNDER_WAVE, PSYWAVE,      TRI_ATTACK,   SUBSTITUTE,   FLASH
	; end

	.DB 0 ; padding
