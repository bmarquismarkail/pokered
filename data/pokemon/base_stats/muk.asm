	.DB DEX_MUK ; pokedex id

	.DB 105, 105,  75,  50,  65
	;   hp  atk  def  spd  spc

	.DB POISON, POISON ; type
	.DB 75 ; catch rate
	.DB 157 ; base exp

	.INCBIN "gfx/pokemon/front/muk.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MukPicFront, MukPicBack

	.DB POUND, DISABLE, POISON_GAS, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    HYPER_BEAM,   RAGE,         MEGA_DRAIN,   \
	     THUNDERBOLT,  THUNDER,      MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SELFDESTRUCT, FIRE_BLAST,   REST,         EXPLOSION,    SUBSTITUTE
	; end

	.DB 0 ; padding
