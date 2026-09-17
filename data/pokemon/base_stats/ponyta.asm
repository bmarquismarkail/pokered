	.DB DEX_PONYTA ; pokedex id

	.DB  50,  85,  55,  90,  65
	;   hp  atk  def  spd  spc

	.DB FIRE, FIRE ; type
	.DB 190 ; catch rate
	.DB 152 ; base exp

	.INCBIN "gfx/pokemon/front/ponyta.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PonytaPicFront, PonytaPicBack

	.DB EMBER, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     FIRE_BLAST,   SWIFT,        SKULL_BASH,   REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
