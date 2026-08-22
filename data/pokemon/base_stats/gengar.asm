	.DB DEX_GENGAR ; pokedex id

	.DB  60,  65,  60, 110, 130
	;   hp  atk  def  spd  spc

	.DB GHOST, POISON ; type
	.DB 45 ; catch rate
	.DB 190 ; base exp

	.INCBIN "gfx/pokemon/front/gengar.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW GengarPicFront, GengarPicBack

	.DB LICK, CONFUSE_RAY, NIGHT_SHADE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         MEGA_DRAIN,   THUNDERBOLT,  THUNDER,      PSYCHIC_M,    \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         METRONOME,    SELFDESTRUCT, \
	     SKULL_BASH,   DREAM_EATER,  REST,         PSYWAVE,      EXPLOSION,    \
	     SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
