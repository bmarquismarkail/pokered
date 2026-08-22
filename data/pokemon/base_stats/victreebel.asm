	.DB DEX_VICTREEBEL ; pokedex id

	.DB  80, 105,  65,  70, 100
	;   hp  atk  def  spd  spc

	.DB GRASS, POISON ; type
	.DB 45 ; catch rate
	.DB 191 ; base exp

	.INCBIN "gfx/pokemon/front/victreebel.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW VictreebelPicFront, VictreebelPicBack

	.DB SLEEP_POWDER, STUN_SPORE, ACID, RAZOR_LEAF ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         REST,         SUBSTITUTE,   \
	     CUT
	; end

	.DB 0 ; padding
