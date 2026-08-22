	.DB DEX_VAPOREON ; pokedex id

	.DB 130,  65,  60,  65, 110
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 45 ; catch rate
	.DB 196 ; base exp

	.INCBIN "gfx/pokemon/front/vaporeon.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW VaporeonPicFront, VaporeonPicBack

	.DB TACKLE, SAND_ATTACK, QUICK_ATTACK, WATER_GUN ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SWIFT,        \
	     SKULL_BASH,   REST,         SUBSTITUTE,   SURF
	; end

	.DB 0 ; padding
