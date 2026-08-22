	.DB DEX_KRABBY ; pokedex id

	.DB  30, 105,  90,  50,  25
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 225 ; catch rate
	.DB 115 ; base exp

	.INCBIN "gfx/pokemon/front/krabby.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW KrabbyPicFront, KrabbyPicBack

	.DB BUBBLE, LEER, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         REST,         SUBSTITUTE,   \
	     CUT,          SURF,         STRENGTH
	; end

	.DB 0 ; padding
