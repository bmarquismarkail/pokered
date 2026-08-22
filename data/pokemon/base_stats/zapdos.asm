	.DB DEX_ZAPDOS ; pokedex id

	.DB  90,  90,  85, 100, 125
	;   hp  atk  def  spd  spc

	.DB ELECTRIC, FLYING ; type
	.DB 3 ; catch rate
	.DB 216 ; base exp

	.INCBIN "gfx/pokemon/front/zapdos.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ZapdosPicFront, ZapdosPicBack

	.DB THUNDERSHOCK, DRILL_PECK, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         THUNDERBOLT,  THUNDER,      MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         SWIFT,        SKY_ATTACK,   \
	     REST,         THUNDER_WAVE, SUBSTITUTE,   FLY,          FLASH
	; end

	.DB 0 ; padding
