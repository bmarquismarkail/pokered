	.DB DEX_ODDISH ; pokedex id

	.DB  45,  50,  55,  30,  75
	;   hp  atk  def  spd  spc

	.DB GRASS, POISON ; type
	.DB 255 ; catch rate
	.DB 78 ; base exp

	.INCBIN "gfx/pokemon/front/oddish.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW OddishPicFront, OddishPicBack

	.DB ABSORB, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         REST,         SUBSTITUTE,   CUT
	; end

	.DB 0 ; padding
