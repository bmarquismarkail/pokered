	.DB DEX_GOLEM ; pokedex id

	.DB  80, 110, 130,  45,  55
	;   hp  atk  def  spd  spc

	.DB ROCK, GROUND ; type
	.DB 45 ; catch rate
	.DB 177 ; base exp

	.INCBIN "gfx/pokemon/front/golem.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW GolemPicFront, GolemPicBack

	.DB TACKLE, DEFENSE_CURL, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         METRONOME,    SELFDESTRUCT, FIRE_BLAST,   \
	     REST,         EXPLOSION,    ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
