	.DB DEX_GLOOM ; pokedex id

	.DB  60,  65,  70,  40,  85
	;   hp  atk  def  spd  spc

	.DB GRASS, POISON ; type
	.DB 120 ; catch rate
	.DB 132 ; base exp

	.INCBIN "gfx/pokemon/front/gloom.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW GloomPicFront, GloomPicBack

	.DB ABSORB, POISONPOWDER, STUN_SPORE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     MEGA_DRAIN,   SOLARBEAM,    MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         REST,         SUBSTITUTE,   CUT
	; end

	.DB 0 ; padding
