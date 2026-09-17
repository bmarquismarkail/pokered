	.DB DEX_PERSIAN ; pokedex id

	.DB  65,  70,  60, 115,  65
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 90 ; catch rate
	.DB 148 ; base exp

	.INCBIN "gfx/pokemon/front/persian.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PersianPicFront, PersianPicBack

	.DB SCRATCH, GROWL, BITE, SCREECH ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    HYPER_BEAM,   PAY_DAY,      RAGE,         THUNDERBOLT,  \
	     THUNDER,      MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
	     SKULL_BASH,   REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
