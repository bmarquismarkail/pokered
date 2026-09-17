	.DB DEX_PIDGEOT ; pokedex id

	.DB  83,  80,  75,  91,  70
	;   hp  atk  def  spd  spc

	.DB NORMAL, FLYING ; type
	.DB 45 ; catch rate
	.DB 172 ; base exp

	.INCBIN "gfx/pokemon/front/pidgeot.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PidgeotPicFront, PidgeotPicBack

	.DB GUST, SAND_ATTACK, QUICK_ATTACK, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SWIFT,        SKY_ATTACK,   REST,         SUBSTITUTE,   \
	     FLY
	; end

	.DB 0 ; padding
