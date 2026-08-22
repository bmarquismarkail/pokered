	.DB DEX_GRAVELER ; pokedex id

	.DB  55,  95, 115,  35,  45
	;   hp  atk  def  spd  spc

	.DB ROCK, GROUND ; type
	.DB 120 ; catch rate
	.DB 134 ; base exp

	.INCBIN "gfx/pokemon/front/graveler.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW GravelerPicFront, GravelerPicBack

	.DB TACKLE, DEFENSE_CURL, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         EARTHQUAKE,   \
	     FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     METRONOME,    SELFDESTRUCT, FIRE_BLAST,   REST,         EXPLOSION,    \
	     ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
