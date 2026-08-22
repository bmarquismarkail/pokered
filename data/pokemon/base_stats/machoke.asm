	.DB DEX_MACHOKE ; pokedex id

	.DB  80, 100,  70,  45,  50
	;   hp  atk  def  spd  spc

	.DB FIGHTING, FIGHTING ; type
	.DB 90 ; catch rate
	.DB 146 ; base exp

	.INCBIN "gfx/pokemon/front/machoke.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MachokePicFront, MachokePicBack

	.DB KARATE_CHOP, LOW_KICK, LEER, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         METRONOME,    FIRE_BLAST,   SKULL_BASH,   REST,         \
	     ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
