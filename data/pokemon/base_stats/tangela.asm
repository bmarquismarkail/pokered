	.DB DEX_TANGELA ; pokedex id

	.DB  65,  55, 115,  60, 100
	;   hp  atk  def  spd  spc

	.DB GRASS, GRASS ; type
	.DB 45 ; catch rate
	.DB 166 ; base exp

	.INCBIN "gfx/pokemon/front/tangela.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW TangelaPicFront, TangelaPicBack

	.DB CONSTRICT, BIND, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         SKULL_BASH,   REST,         SUBSTITUTE,   \
	     CUT
	; end

	.DB 0 ; padding
