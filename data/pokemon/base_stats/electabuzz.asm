	.DB DEX_ELECTABUZZ ; pokedex id

	.DB  65,  83,  57, 105,  85
	;   hp  atk  def  spd  spc

	.DB ELECTRIC, ELECTRIC ; type
	.DB 45 ; catch rate
	.DB 156 ; base exp

	.INCBIN "gfx/pokemon/front/electabuzz.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ElectabuzzPicFront, ElectabuzzPicBack

	.DB QUICK_ATTACK, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         THUNDERBOLT,  THUNDER,      PSYCHIC_M,    TELEPORT,     \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         METRONOME,    \
	     SWIFT,        SKULL_BASH,   REST,         THUNDER_WAVE, PSYWAVE,      \
	     SUBSTITUTE,   STRENGTH,     FLASH
	; end

	.DB 0 ; padding
