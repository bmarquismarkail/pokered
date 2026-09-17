	.DB DEX_JOLTEON ; pokedex id

	.DB  65,  65,  60, 130, 110
	;   hp  atk  def  spd  spc

	.DB ELECTRIC, ELECTRIC ; type
	.DB 45 ; catch rate
	.DB 197 ; base exp

	.INCBIN "gfx/pokemon/front/jolteon.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW JolteonPicFront, JolteonPicBack

	.DB TACKLE, SAND_ATTACK, QUICK_ATTACK, THUNDERSHOCK ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         THUNDERBOLT,  THUNDER,      MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         SWIFT,        SKULL_BASH,   REST,         \
	     THUNDER_WAVE, SUBSTITUTE,   FLASH
	; end

	.DB 0 ; padding
