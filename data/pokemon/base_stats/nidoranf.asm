	.DB DEX_NIDORAN_F ; pokedex id

	.DB  55,  47,  52,  41,  40
	;   hp  atk  def  spd  spc

	.DB POISON, POISON ; type
	.DB 235 ; catch rate
	.DB 59 ; base exp

	.INCBIN "gfx/pokemon/front/nidoranf.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW NidoranFPicFront, NidoranFPicBack

	.DB GROWL, TACKLE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BLIZZARD,     \
	     RAGE,         THUNDERBOLT,  THUNDER,      MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         SKULL_BASH,   REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
