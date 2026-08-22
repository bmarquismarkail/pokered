	.DB DEX_TENTACOOL ; pokedex id

	.DB  40,  40,  35,  70, 100
	;   hp  atk  def  spd  spc

	.DB WATER, POISON ; type
	.DB 190 ; catch rate
	.DB 105 ; base exp

	.INCBIN "gfx/pokemon/front/tentacool.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW TentacoolPicFront, TentacoolPicBack

	.DB ACID, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         MEGA_DRAIN,   \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SKULL_BASH,   \
	     REST,         SUBSTITUTE,   CUT,          SURF
	; end

	.DB 0 ; padding
