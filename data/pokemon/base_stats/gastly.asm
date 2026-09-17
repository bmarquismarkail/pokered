	.DB DEX_GASTLY ; pokedex id

	.DB  30,  35,  30,  80, 100
	;   hp  atk  def  spd  spc

	.DB GHOST, POISON ; type
	.DB 190 ; catch rate
	.DB 95 ; base exp

	.INCBIN "gfx/pokemon/front/gastly.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW GastlyPicFront, GastlyPicBack

	.DB LICK, CONFUSE_RAY, NIGHT_SHADE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        RAGE,         MEGA_DRAIN,   THUNDERBOLT,  THUNDER,      \
	     PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  BIDE,         SELFDESTRUCT, \
	     DREAM_EATER,  REST,         PSYWAVE,      EXPLOSION,    SUBSTITUTE
	; end

	.DB 0 ; padding
