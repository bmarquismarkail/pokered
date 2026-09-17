	.DB DEX_NIDORAN_M ; pokedex id

	.DB  46,  57,  40,  50,  40
	;   hp  atk  def  spd  spc

	.DB POISON, POISON ; type
	.DB 235 ; catch rate
	.DB 60 ; base exp

	.INCBIN "gfx/pokemon/front/nidoranm.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW NidoranMPicFront, NidoranMPicBack

	.DB LEER, TACKLE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BLIZZARD,     RAGE,         THUNDERBOLT,  THUNDER,      MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         SKULL_BASH,   REST,         \
	     SUBSTITUTE
	; end

	.DB 0 ; padding
