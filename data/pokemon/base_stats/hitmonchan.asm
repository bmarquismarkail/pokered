	.DB DEX_HITMONCHAN ; pokedex id

	.DB  50, 105,  79,  76,  35
	;   hp  atk  def  spd  spc

	.DB FIGHTING, FIGHTING ; type
	.DB 45 ; catch rate
	.DB 140 ; base exp

	.INCBIN "gfx/pokemon/front/hitmonchan.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW HitmonchanPicFront, HitmonchanPicBack

	.DB COMET_PUNCH, AGILITY, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         METRONOME,    SWIFT,        \
	     SKULL_BASH,   REST,         SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
