	.DB DEX_RATICATE ; pokedex id

	.DB  55,  81,  60,  97,  50
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 90 ; catch rate
	.DB 116 ; base exp

	.INCBIN "gfx/pokemon/front/raticate.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW RaticatePicFront, RaticatePicBack

	.DB TACKLE, TAIL_WHIP, QUICK_ATTACK, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         \
	     THUNDERBOLT,  THUNDER,      DIG,          MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         SWIFT,        SKULL_BASH,   REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
