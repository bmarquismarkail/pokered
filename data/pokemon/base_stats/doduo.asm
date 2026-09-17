	.DB DEX_DODUO ; pokedex id

	.DB  35,  85,  45,  75,  35
	;   hp  atk  def  spd  spc

	.DB NORMAL, FLYING ; type
	.DB 190 ; catch rate
	.DB 96 ; base exp

	.INCBIN "gfx/pokemon/front/doduo.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW DoduoPicFront, DoduoPicBack

	.DB PECK, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm WHIRLWIND,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SKULL_BASH,   SKY_ATTACK,   REST,         TRI_ATTACK,   SUBSTITUTE,   \
	     FLY
	; end

	.DB 0 ; padding
