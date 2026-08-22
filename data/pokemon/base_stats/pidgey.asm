	.DB DEX_PIDGEY ; pokedex id

	.DB  40,  45,  40,  56,  35
	;   hp  atk  def  spd  spc

	.DB NORMAL, FLYING ; type
	.DB 255 ; catch rate
	.DB 55 ; base exp

	.INCBIN "gfx/pokemon/front/pidgey.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PidgeyPicFront, PidgeyPicBack

	.DB GUST, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        SKY_ATTACK,   REST,         SUBSTITUTE,   FLY
	; end

	.DB 0 ; padding
