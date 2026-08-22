	.DB DEX_FLAREON ; pokedex id

	.DB  65, 130,  60,  65, 110
	;   hp  atk  def  spd  spc

	.DB FIRE, FIRE ; type
	.DB 45 ; catch rate
	.DB 198 ; base exp

	.INCBIN "gfx/pokemon/front/flareon.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW FlareonPicFront, FlareonPicBack

	.DB TACKLE, SAND_ATTACK, QUICK_ATTACK, EMBER ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     FIRE_BLAST,   SWIFT,        SKULL_BASH,   REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
