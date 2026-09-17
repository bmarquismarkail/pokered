	.DB DEX_SANDSLASH ; pokedex id

	.DB  75, 100, 110,  65,  55
	;   hp  atk  def  spd  spc

	.DB GROUND, GROUND ; type
	.DB 90 ; catch rate
	.DB 163 ; base exp

	.INCBIN "gfx/pokemon/front/sandslash.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW SandslashPicFront, SandslashPicBack

	.DB SCRATCH, SAND_ATTACK, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   SUBMISSION,   SEISMIC_TOSS, RAGE,         EARTHQUAKE,   \
	     FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SWIFT,        SKULL_BASH,   REST,         ROCK_SLIDE,   SUBSTITUTE,   \
	     CUT,          STRENGTH
	; end

	.DB 0 ; padding
