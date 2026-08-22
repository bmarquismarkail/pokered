	.DB DEX_BEEDRILL ; pokedex id

	.DB  65,  80,  40,  75,  45
	;   hp  atk  def  spd  spc

	.DB BUG, POISON ; type
	.DB 45 ; catch rate
	.DB 159 ; base exp

	.INCBIN "gfx/pokemon/front/beedrill.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW BeedrillPicFront, BeedrillPicBack

	.DB FURY_ATTACK, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MEGA_DRAIN,   MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SWIFT,        SKULL_BASH,   REST,         SUBSTITUTE,   \
	     CUT
	; end

	.DB 0 ; padding
