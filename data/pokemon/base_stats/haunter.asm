	.DB DEX_HAUNTER ; pokedex id

	.DB  45,  50,  45,  95, 115
	;   hp  atk  def  spd  spc

	.DB GHOST, POISON ; type
	.DB 90 ; catch rate
	.DB 126 ; base exp

	.INCBIN "gfx/pokemon/front/haunter.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW HaunterPicFront, HaunterPicBack

	.DB LICK, CONFUSE_RAY, NIGHT_SHADE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        RAGE,         MEGA_DRAIN,   THUNDERBOLT,  THUNDER,      \
	     PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  BIDE,         SELFDESTRUCT, \
	     DREAM_EATER,  REST,         PSYWAVE,      EXPLOSION,    SUBSTITUTE
	; end

	.DB 0 ; padding
