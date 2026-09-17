	.DB DEX_TENTACRUEL ; pokedex id

	.DB  80,  70,  65, 100, 120
	;   hp  atk  def  spd  spc

	.DB WATER, POISON ; type
	.DB 60 ; catch rate
	.DB 205 ; base exp

	.INCBIN "gfx/pokemon/front/tentacruel.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW TentacruelPicFront, TentacruelPicBack

	.DB ACID, SUPERSONIC, WRAP, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         \
	     MEGA_DRAIN,   MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SKULL_BASH,   REST,         SUBSTITUTE,   CUT,          SURF
	; end

	.DB 0 ; padding
