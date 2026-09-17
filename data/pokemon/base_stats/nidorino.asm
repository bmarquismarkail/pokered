	.DB DEX_NIDORINO ; pokedex id

	.DB  61,  72,  57,  65,  55
	;   hp  atk  def  spd  spc

	.DB POISON, POISON ; type
	.DB 120 ; catch rate
	.DB 118 ; base exp

	.INCBIN "gfx/pokemon/front/nidorino.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW NidorinoPicFront, NidorinoPicBack

	.DB LEER, TACKLE, HORN_ATTACK, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         \
	     THUNDERBOLT,  THUNDER,      MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SKULL_BASH,   REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
