	.DB DEX_GEODUDE ; pokedex id

	.DB  40,  80, 100,  20,  30
	;   hp  atk  def  spd  spc

	.DB ROCK, GROUND ; type
	.DB 255 ; catch rate
	.DB 86 ; base exp

	.INCBIN "gfx/pokemon/front/geodude.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW GeodudePicFront, GeodudePicBack

	.DB TACKLE, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         EARTHQUAKE,   \
	     FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     METRONOME,    SELFDESTRUCT, FIRE_BLAST,   REST,         EXPLOSION,    \
	     ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
