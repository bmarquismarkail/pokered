	.DB DEX_KINGLER ; pokedex id

	.DB  55, 130, 115,  75,  50
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 60 ; catch rate
	.DB 206 ; base exp

	.INCBIN "gfx/pokemon/front/kingler.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW KinglerPicFront, KinglerPicBack

	.DB BUBBLE, LEER, VICEGRIP, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         REST,         \
	     SUBSTITUTE,   CUT,          SURF,         STRENGTH
	; end

	.DB 0 ; padding
