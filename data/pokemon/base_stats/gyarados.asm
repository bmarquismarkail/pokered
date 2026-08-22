	.DB DEX_GYARADOS ; pokedex id

	.DB  95, 125,  79,  81, 100
	;   hp  atk  def  spd  spc

	.DB WATER, FLYING ; type
	.DB 45 ; catch rate
	.DB 214 ; base exp

	.INCBIN "gfx/pokemon/front/gyarados.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW GyaradosPicFront, GyaradosPicBack

	.DB BITE, DRAGON_RAGE, LEER, HYDRO_PUMP ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         \
	     DRAGON_RAGE,  THUNDERBOLT,  THUNDER,      MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         FIRE_BLAST,   SKULL_BASH,   REST,         \
	     SUBSTITUTE,   SURF,         STRENGTH
	; end

	.DB 0 ; padding
