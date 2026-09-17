	.DB DEX_MACHOP ; pokedex id

	.DB  70,  80,  50,  35,  35
	;   hp  atk  def  spd  spc

	.DB FIGHTING, FIGHTING ; type
	.DB 180 ; catch rate
	.DB 88 ; base exp

	.INCBIN "gfx/pokemon/front/machop.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MachopPicFront, MachopPicBack

	.DB KARATE_CHOP, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         METRONOME,    FIRE_BLAST,   SKULL_BASH,   REST,         \
	     ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
