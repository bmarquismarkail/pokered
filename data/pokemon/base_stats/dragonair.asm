	.DB DEX_DRAGONAIR ; pokedex id

	.DB  61,  84,  65,  70,  70
	;   hp  atk  def  spd  spc

	.DB DRAGON, DRAGON ; type
	.DB 45 ; catch rate
	.DB 144 ; base exp

	.INCBIN "gfx/pokemon/front/dragonair.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW DragonairPicFront, DragonairPicBack

	.DB WRAP, LEER, THUNDER_WAVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         \
	     DRAGON_RAGE,  THUNDERBOLT,  THUNDER,      MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         FIRE_BLAST,   SWIFT,        SKULL_BASH,   \
	     REST,         THUNDER_WAVE, SUBSTITUTE,   SURF
	; end

	.DB 0 ; padding
