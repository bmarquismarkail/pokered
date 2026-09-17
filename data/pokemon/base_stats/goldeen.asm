	.DB DEX_GOLDEEN ; pokedex id

	.DB  45,  67,  60,  63,  50
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 225 ; catch rate
	.DB 111 ; base exp

	.INCBIN "gfx/pokemon/front/goldeen.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW GoldeenPicFront, GoldeenPicBack

	.DB PECK, TAIL_WHIP, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         SWIFT,        SKULL_BASH,   REST,         \
	     SUBSTITUTE,   SURF
	; end

	.DB 0 ; padding
