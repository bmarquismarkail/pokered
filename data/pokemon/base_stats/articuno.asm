	.DB DEX_ARTICUNO ; pokedex id

	.DB  90,  85, 100,  85, 125
	;   hp  atk  def  spd  spc

	.DB ICE, FLYING ; type
	.DB 3 ; catch rate
	.DB 215 ; base exp

	.INCBIN "gfx/pokemon/front/articuno.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ArticunoPicFront, ArticunoPicBack

	.DB PECK, ICE_BEAM, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   \
	     RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        SKY_ATTACK,   REST,         SUBSTITUTE,   FLY
	; end

	.DB 0 ; padding
