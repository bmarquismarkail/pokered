	.DB DEX_MEOWTH ; pokedex id

	.DB  40,  45,  35,  90,  40
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 255 ; catch rate
	.DB 69 ; base exp

	.INCBIN "gfx/pokemon/front/meowth.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MeowthPicFront, MeowthPicBack

	.DB SCRATCH, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    PAY_DAY,      RAGE,         THUNDERBOLT,  THUNDER,      \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        SKULL_BASH,   \
	     REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
