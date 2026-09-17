	.DB DEX_ARCANINE ; pokedex id

	.DB  90, 110,  80,  95,  80
	;   hp  atk  def  spd  spc

	.DB FIRE, FIRE ; type
	.DB 75 ; catch rate
	.DB 213 ; base exp

	.INCBIN "gfx/pokemon/front/arcanine.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ArcaninePicFront, ArcaninePicBack

	.DB ROAR, EMBER, LEER, TAKE_DOWN ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         DRAGON_RAGE,  DIG,          TELEPORT,     MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         FIRE_BLAST,   SWIFT,        \
	     SKULL_BASH,   REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
