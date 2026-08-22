	.DB DEX_RATTATA ; pokedex id

	.DB  30,  56,  35,  72,  25
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 255 ; catch rate
	.DB 57 ; base exp

	.INCBIN "gfx/pokemon/front/rattata.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW RattataPicFront, RattataPicBack

	.DB TACKLE, TAIL_WHIP, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    BLIZZARD,     RAGE,         THUNDERBOLT,  THUNDER,      \
	     DIG,          MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
	     SKULL_BASH,   REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
