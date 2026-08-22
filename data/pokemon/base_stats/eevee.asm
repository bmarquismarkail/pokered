	.DB DEX_EEVEE ; pokedex id

	.DB  55,  55,  50,  55,  65
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 45 ; catch rate
	.DB 92 ; base exp

	.INCBIN "gfx/pokemon/front/eevee.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW EeveePicFront, EeveePicBack

	.DB TACKLE, SAND_ATTACK, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SWIFT,        \
	     SKULL_BASH,   REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
