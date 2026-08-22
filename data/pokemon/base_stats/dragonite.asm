	.DB DEX_DRAGONITE ; pokedex id

	.DB  91, 134,  95,  80, 100
	;   hp  atk  def  spd  spc

	.DB DRAGON, FLYING ; type
	.DB 45 ; catch rate
	.DB 218 ; base exp

	.INCBIN "gfx/pokemon/front/dragonite.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW DragonitePicFront, DragonitePicBack

	.DB WRAP, LEER, THUNDER_WAVE, AGILITY ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   RAGE,         DRAGON_RAGE,  THUNDERBOLT,  THUNDER,      \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         FIRE_BLAST,   \
	     SWIFT,        SKULL_BASH,   REST,         THUNDER_WAVE, SUBSTITUTE,   \
	     SURF,         STRENGTH
	; end

	.DB 0 ; padding
