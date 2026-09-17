	.DB DEX_VULPIX ; pokedex id

	.DB  38,  41,  40,  65,  65
	;   hp  atk  def  spd  spc

	.DB FIRE, FIRE ; type
	.DB 190 ; catch rate
	.DB 63 ; base exp

	.INCBIN "gfx/pokemon/front/vulpix.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW VulpixPicFront, VulpixPicBack

	.DB EMBER, TAIL_WHIP, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     DIG,          MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     FIRE_BLAST,   SWIFT,        SKULL_BASH,   REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
