	.DB DEX_DRATINI ; pokedex id

	.DB  41,  64,  45,  50,  50
	;   hp  atk  def  spd  spc

	.DB DRAGON, DRAGON ; type
	.DB 45 ; catch rate
	.DB 67 ; base exp

	.INCBIN "gfx/pokemon/front/dratini.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW DratiniPicFront, DratiniPicBack

	.DB WRAP, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         DRAGON_RAGE,  \
	     THUNDERBOLT,  THUNDER,      MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         FIRE_BLAST,   SWIFT,        SKULL_BASH,   REST,         \
	     THUNDER_WAVE, SUBSTITUTE,   SURF
	; end

	.DB 0 ; padding
