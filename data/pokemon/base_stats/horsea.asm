	.DB DEX_HORSEA ; pokedex id

	.DB  30,  40,  70,  60,  70
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 225 ; catch rate
	.DB 83 ; base exp

	.INCBIN "gfx/pokemon/front/horsea.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW HorseaPicFront, HorseaPicBack

	.DB BUBBLE, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    \
	     ICE_BEAM,     BLIZZARD,     RAGE,         MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         SWIFT,        SKULL_BASH,   REST,         SUBSTITUTE,   \
	     SURF
	; end

	.DB 0 ; padding
