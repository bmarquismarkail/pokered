	.DB DEX_SEAKING ; pokedex id

	.DB  80,  92,  65,  68,  80
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 60 ; catch rate
	.DB 170 ; base exp

	.INCBIN "gfx/pokemon/front/seaking.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW SeakingPicFront, SeakingPicBack

	.DB PECK, TAIL_WHIP, SUPERSONIC, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        SKULL_BASH,   \
	     REST,         SUBSTITUTE,   SURF
	; end

	.DB 0 ; padding
