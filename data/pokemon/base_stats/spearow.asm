	.DB DEX_SPEAROW ; pokedex id

	.DB  40,  60,  30,  70,  31
	;   hp  atk  def  spd  spc

	.DB NORMAL, FLYING ; type
	.DB 255 ; catch rate
	.DB 58 ; base exp

	.INCBIN "gfx/pokemon/front/spearow.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW SpearowPicFront, SpearowPicBack

	.DB PECK, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
	     SKY_ATTACK,   REST,         SUBSTITUTE,   FLY
	; end

	.DB 0 ; padding
