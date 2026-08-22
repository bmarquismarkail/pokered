	.DB DEX_MACHAMP ; pokedex id

	.DB  90, 130,  80,  55,  65
	;   hp  atk  def  spd  spc

	.DB FIGHTING, FIGHTING ; type
	.DB 45 ; catch rate
	.DB 193 ; base exp

	.INCBIN "gfx/pokemon/front/machamp.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MachampPicFront, MachampPicBack

	.DB KARATE_CHOP, LOW_KICK, LEER, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         METRONOME,    FIRE_BLAST,   SKULL_BASH,   \
	     REST,         ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
