	.DB DEX_SCYTHER ; pokedex id

	.DB  70, 110,  80, 105,  55
	;   hp  atk  def  spd  spc

	.DB BUG, FLYING ; type
	.DB 45 ; catch rate
	.DB 187 ; base exp

	.INCBIN "gfx/pokemon/front/scyther.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ScytherPicFront, ScytherPicBack

	.DB QUICK_ATTACK, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
	     SKULL_BASH,   REST,         SUBSTITUTE,   CUT
	; end

	.DB 0 ; padding
