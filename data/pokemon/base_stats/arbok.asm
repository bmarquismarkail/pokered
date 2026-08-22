	.DB DEX_ARBOK ; pokedex id

	.DB  60,  85,  69,  80,  65
	;   hp  atk  def  spd  spc

	.DB POISON, POISON ; type
	.DB 90 ; catch rate
	.DB 147 ; base exp

	.INCBIN "gfx/pokemon/front/arbok.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ArbokPicFront, ArbokPicBack

	.DB WRAP, LEER, POISON_STING, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MEGA_DRAIN,   EARTHQUAKE,   FISSURE,      DIG,          \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SKULL_BASH,   REST,         \
	     ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
