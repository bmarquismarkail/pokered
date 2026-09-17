	.DB DEX_NIDORINA ; pokedex id

	.DB  70,  62,  67,  56,  55
	;   hp  atk  def  spd  spc

	.DB POISON, POISON ; type
	.DB 120 ; catch rate
	.DB 117 ; base exp

	.INCBIN "gfx/pokemon/front/nidorina.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW NidorinaPicFront, NidorinaPicBack

	.DB GROWL, TACKLE, SCRATCH, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         \
	     THUNDERBOLT,  THUNDER,      MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SKULL_BASH,   REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
