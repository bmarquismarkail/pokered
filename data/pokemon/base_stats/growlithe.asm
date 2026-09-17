	.DB DEX_GROWLITHE ; pokedex id

	.DB  55,  70,  45,  60,  50
	;   hp  atk  def  spd  spc

	.DB FIRE, FIRE ; type
	.DB 190 ; catch rate
	.DB 91 ; base exp

	.INCBIN "gfx/pokemon/front/growlithe.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW GrowlithePicFront, GrowlithePicBack

	.DB BITE, ROAR, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     DRAGON_RAGE,  DIG,          MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         FIRE_BLAST,   SWIFT,        SKULL_BASH,   REST,         \
	     SUBSTITUTE
	; end

	.DB 0 ; padding
