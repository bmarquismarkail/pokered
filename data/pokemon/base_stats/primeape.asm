	.DB DEX_PRIMEAPE ; pokedex id

	.DB  65, 105,  60,  95,  60
	;   hp  atk  def  spd  spc

	.DB FIGHTING, FIGHTING ; type
	.DB 75 ; catch rate
	.DB 149 ; base exp

	.INCBIN "gfx/pokemon/front/primeape.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PrimeapePicFront, PrimeapePicBack

	.DB SCRATCH, LEER, KARATE_CHOP, FURY_SWIPES ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   PAY_DAY,      SUBMISSION,   COUNTER,      \
	     SEISMIC_TOSS, RAGE,         THUNDERBOLT,  THUNDER,      DIG,          \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         METRONOME,    SWIFT,        \
	     SKULL_BASH,   REST,         ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
