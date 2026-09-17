	.DB DEX_ZUBAT ; pokedex id

	.DB  40,  45,  35,  55,  40
	;   hp  atk  def  spd  spc

	.DB POISON, FLYING ; type
	.DB 255 ; catch rate
	.DB 54 ; base exp

	.INCBIN "gfx/pokemon/front/zubat.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ZubatPicFront, ZubatPicBack

	.DB LEECH_LIFE, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         MEGA_DRAIN,   MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SWIFT,        REST,         SUBSTITUTE
	; end

	.DB 0 ; padding
