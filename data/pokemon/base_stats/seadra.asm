	.DB DEX_SEADRA ; pokedex id

	.DB  55,  65,  95,  85,  95
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 75 ; catch rate
	.DB 155 ; base exp

	.INCBIN "gfx/pokemon/front/seadra.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW SeadraPicFront, SeadraPicBack

	.DB BUBBLE, SMOKESCREEN, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    \
	     ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         SWIFT,        SKULL_BASH,   REST,         \
	     SUBSTITUTE,   SURF
	; end

	.DB 0 ; padding
