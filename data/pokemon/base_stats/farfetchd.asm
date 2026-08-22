	.DB DEX_FARFETCHD ; pokedex id

	.DB  52,  65,  55,  60,  58
	;   hp  atk  def  spd  spc

	.DB NORMAL, FLYING ; type
	.DB 45 ; catch rate
	.DB 94 ; base exp

	.INCBIN "gfx/pokemon/front/farfetchd.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW FarfetchdPicFront, FarfetchdPicBack

	.DB PECK, SAND_ATTACK, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   SWORDS_DANCE, WHIRLWIND,    TOXIC,        BODY_SLAM,    \
	     TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         SWIFT,        SKULL_BASH,   REST,         \
	     SUBSTITUTE,   CUT,          FLY
	; end

	.DB 0 ; padding
