	.DB DEX_VENOMOTH ; pokedex id

	.DB  70,  65,  60,  90,  90
	;   hp  atk  def  spd  spc

	.DB BUG, POISON ; type
	.DB 75 ; catch rate
	.DB 138 ; base exp

	.INCBIN "gfx/pokemon/front/venomoth.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW VenomothPicFront, VenomothPicBack

	.DB TACKLE, DISABLE, POISONPOWDER, LEECH_LIFE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    PSYCHIC_M,    \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        REST,         PSYWAVE,      SUBSTITUTE
	; end

	.DB 0 ; padding
