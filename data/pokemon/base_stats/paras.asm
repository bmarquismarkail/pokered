	.DB DEX_PARAS ; pokedex id

	.DB  35,  70,  55,  25,  55
	;   hp  atk  def  spd  spc

	.DB BUG, GRASS ; type
	.DB 190 ; catch rate
	.DB 70 ; base exp

	.INCBIN "gfx/pokemon/front/paras.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ParasPicFront, ParasPicBack

	.DB SCRATCH, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   SOLARBEAM,    DIG,          MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         SKULL_BASH,   REST,         \
	     SUBSTITUTE,   CUT
	; end

	.DB 0 ; padding
