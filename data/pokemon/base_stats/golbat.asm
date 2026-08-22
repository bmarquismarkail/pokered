	.DB DEX_GOLBAT ; pokedex id

	.DB  75,  80,  70,  90,  75
	;   hp  atk  def  spd  spc

	.DB POISON, FLYING ; type
	.DB 90 ; catch rate
	.DB 171 ; base exp

	.INCBIN "gfx/pokemon/front/golbat.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW GolbatPicFront, GolbatPicBack

	.DB LEECH_LIFE, SCREECH, BITE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         SWIFT,        REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
