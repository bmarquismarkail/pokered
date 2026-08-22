	.DB DEX_OMANYTE ; pokedex id

	.DB  35,  40, 100,  35,  90
	;   hp  atk  def  spd  spc

	.DB ROCK, WATER ; type
	.DB 45 ; catch rate
	.DB 120 ; base exp

	.INCBIN "gfx/pokemon/front/omanyte.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW OmanytePicFront, OmanytePicBack

	.DB WATER_GUN, WITHDRAW, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         REST,         SUBSTITUTE,   \
	     SURF
	; end

	.DB 0 ; padding
