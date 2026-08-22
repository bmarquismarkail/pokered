	.DB DEX_PIDGEOTTO ; pokedex id

	.DB  63,  60,  55,  71,  50
	;   hp  atk  def  spd  spc

	.DB NORMAL, FLYING ; type
	.DB 120 ; catch rate
	.DB 113 ; base exp

	.INCBIN "gfx/pokemon/front/pidgeotto.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PidgeottoPicFront, PidgeottoPicBack

	.DB GUST, SAND_ATTACK, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        SKY_ATTACK,   REST,         SUBSTITUTE,   FLY
	; end

	.DB 0 ; padding
