	.DB DEX_MOLTRES ; pokedex id

	.DB  90, 100,  90,  90, 125
	;   hp  atk  def  spd  spc

	.DB FIRE, FLYING ; type
	.DB 3 ; catch rate
	.DB 217 ; base exp

	.INCBIN "gfx/pokemon/front/moltres.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MoltresPicFront, MoltresPicBack

	.DB PECK, FIRE_SPIN, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         FIRE_BLAST,   SWIFT,        SKY_ATTACK,   REST,         \
	     SUBSTITUTE,   FLY
	; end

	.DB 0 ; padding
