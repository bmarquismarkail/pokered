	.DB DEX_BELLSPROUT ; pokedex id

	.DB  50,  75,  35,  40,  70
	;   hp  atk  def  spd  spc

	.DB GRASS, POISON ; type
	.DB 255 ; catch rate
	.DB 84 ; base exp

	.INCBIN "gfx/pokemon/front/bellsprout.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW BellsproutPicFront, BellsproutPicBack

	.DB VINE_WHIP, GROWTH, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         REST,         SUBSTITUTE,   CUT
	; end

	.DB 0 ; padding
