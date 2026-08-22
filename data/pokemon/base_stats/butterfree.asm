	.DB DEX_BUTTERFREE ; pokedex id

	.DB  60,  45,  50,  70,  80
	;   hp  atk  def  spd  spc

	.DB BUG, FLYING ; type
	.DB 45 ; catch rate
	.DB 160 ; base exp

	.INCBIN "gfx/pokemon/front/butterfree.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ButterfreePicFront, ButterfreePicBack

	.DB CONFUSION, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    PSYCHIC_M,    \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        REST,         PSYWAVE,      SUBSTITUTE
	; end

	.DB 0 ; padding
