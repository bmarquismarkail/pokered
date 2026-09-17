	.DB DEX_MANKEY ; pokedex id

	.DB  40,  80,  35,  70,  35
	;   hp  atk  def  spd  spc

	.DB FIGHTING, FIGHTING ; type
	.DB 190 ; catch rate
	.DB 74 ; base exp

	.INCBIN "gfx/pokemon/front/mankey.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MankeyPicFront, MankeyPicBack

	.DB SCRATCH, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  PAY_DAY,      SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         THUNDERBOLT,  THUNDER,      DIG,          MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         METRONOME,    SWIFT,        SKULL_BASH,   \
	     REST,         ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
