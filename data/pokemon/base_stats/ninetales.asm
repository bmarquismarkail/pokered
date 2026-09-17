	.DB DEX_NINETALES ; pokedex id

	.DB  73,  76,  75, 100, 100
	;   hp  atk  def  spd  spc

	.DB FIRE, FIRE ; type
	.DB 75 ; catch rate
	.DB 178 ; base exp

	.INCBIN "gfx/pokemon/front/ninetales.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW NinetalesPicFront, NinetalesPicBack

	.DB EMBER, TAIL_WHIP, QUICK_ATTACK, ROAR ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         DIG,          MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         FIRE_BLAST,   SWIFT,        SKULL_BASH,   REST,         \
	     SUBSTITUTE
	; end

	.DB 0 ; padding
