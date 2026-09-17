	.DB DEX_DEWGONG ; pokedex id

	.DB  90,  70,  80,  70,  95
	;   hp  atk  def  spd  spc

	.DB WATER, ICE ; type
	.DB 75 ; catch rate
	.DB 176 ; base exp

	.INCBIN "gfx/pokemon/front/dewgong.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW DewgongPicFront, DewgongPicBack

	.DB HEADBUTT, GROWL, AURORA_BEAM, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   \
	     PAY_DAY,      RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SKULL_BASH,   REST,         SUBSTITUTE,   SURF,         STRENGTH
	; end

	.DB 0 ; padding
