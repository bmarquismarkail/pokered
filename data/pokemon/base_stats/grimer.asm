	.DB DEX_GRIMER ; pokedex id

	.DB  80,  80,  50,  25,  40
	;   hp  atk  def  spd  spc

	.DB POISON, POISON ; type
	.DB 190 ; catch rate
	.DB 90 ; base exp

	.INCBIN "gfx/pokemon/front/grimer.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW GrimerPicFront, GrimerPicBack

	.DB POUND, DISABLE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    RAGE,         MEGA_DRAIN,   THUNDERBOLT,  \
	     THUNDER,      MIMIC,        DOUBLE_TEAM,  BIDE,         SELFDESTRUCT, \
	     FIRE_BLAST,   REST,         EXPLOSION,    SUBSTITUTE
	; end

	.DB 0 ; padding
