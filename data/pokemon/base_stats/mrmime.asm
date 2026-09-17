	.DB DEX_MR_MIME ; pokedex id

	.DB  40,  45,  65,  90, 100
	;   hp  atk  def  spd  spc

	.DB PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	.DB 45 ; catch rate
	.DB 136 ; base exp

	.INCBIN "gfx/pokemon/front/mr.mime.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MrMimePicFront, MrMimePicBack

	.DB CONFUSION, BARRIER, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         SOLARBEAM,    THUNDERBOLT,  THUNDER,      PSYCHIC_M,    \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     METRONOME,    SKULL_BASH,   REST,         THUNDER_WAVE, PSYWAVE,      \
	     SUBSTITUTE,   FLASH
	; end

	.DB 0 ; padding
