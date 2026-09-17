	.DB DEX_VILEPLUME ; pokedex id

	.DB  75,  80,  85,  50, 100
	;   hp  atk  def  spd  spc

	.DB GRASS, POISON ; type
	.DB 45 ; catch rate
	.DB 184 ; base exp

	.INCBIN "gfx/pokemon/front/vileplume.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW VileplumePicFront, VileplumePicBack

	.DB STUN_SPORE, SLEEP_POWDER, ACID, PETAL_DANCE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         REST,         SUBSTITUTE,   \
	     CUT
	; end

	.DB 0 ; padding
