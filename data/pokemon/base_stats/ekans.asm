	.DB DEX_EKANS ; pokedex id

	.DB  35,  60,  44,  55,  40
	;   hp  atk  def  spd  spc

	.DB POISON, POISON ; type
	.DB 255 ; catch rate
	.DB 62 ; base exp

	.INCBIN "gfx/pokemon/front/ekans.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW EkansPicFront, EkansPicBack

	.DB WRAP, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     MEGA_DRAIN,   EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         SKULL_BASH,   REST,         ROCK_SLIDE,   \
	     SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
