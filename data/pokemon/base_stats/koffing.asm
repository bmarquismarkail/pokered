	.DB DEX_KOFFING ; pokedex id

	.DB  40,  65,  95,  35,  60
	;   hp  atk  def  spd  spc

	.DB POISON, POISON ; type
	.DB 190 ; catch rate
	.DB 114 ; base exp

	.INCBIN "gfx/pokemon/front/koffing.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW KoffingPicFront, KoffingPicBack

	.DB TACKLE, SMOG, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        RAGE,         THUNDERBOLT,  THUNDER,      MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         SELFDESTRUCT, FIRE_BLAST,   REST,         \
	     EXPLOSION,    SUBSTITUTE
	; end

	.DB 0 ; padding
