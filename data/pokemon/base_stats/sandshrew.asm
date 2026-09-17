	.DB DEX_SANDSHREW ; pokedex id

	.DB  50,  75,  85,  40,  30
	;   hp  atk  def  spd  spc

	.DB GROUND, GROUND ; type
	.DB 255 ; catch rate
	.DB 93 ; base exp

	.INCBIN "gfx/pokemon/front/sandshrew.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW SandshrewPicFront, SandshrewPicBack

	.DB SCRATCH, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     SUBMISSION,   SEISMIC_TOSS, RAGE,         EARTHQUAKE,   FISSURE,      \
	     DIG,          MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
	     SKULL_BASH,   REST,         ROCK_SLIDE,   SUBSTITUTE,   CUT,          \
	     STRENGTH
	; end

	.DB 0 ; padding
