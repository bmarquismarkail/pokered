	.DB DEX_SEEL ; pokedex id

	.DB  65,  45,  55,  45,  70
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 190 ; catch rate
	.DB 100 ; base exp

	.INCBIN "gfx/pokemon/front/seel.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW SeelPicFront, SeelPicBack

	.DB HEADBUTT, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     PAY_DAY,      \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         SKULL_BASH,   \
	     REST,         SUBSTITUTE,   SURF,         STRENGTH
	; end

	.DB 0 ; padding
