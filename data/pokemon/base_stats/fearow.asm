	.DB DEX_FEAROW ; pokedex id

	.DB  65,  90,  65, 100,  61
	;   hp  atk  def  spd  spc

	.DB NORMAL, FLYING ; type
	.DB 90 ; catch rate
	.DB 162 ; base exp

	.INCBIN "gfx/pokemon/front/fearow.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW FearowPicFront, FearowPicBack

	.DB PECK, GROWL, LEER, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SWIFT,        SKY_ATTACK,   REST,         SUBSTITUTE,   FLY
	; end

	.DB 0 ; padding
