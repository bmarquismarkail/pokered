	.DB DEX_AERODACTYL ; pokedex id

	.DB  80, 105,  65, 130,  60
	;   hp  atk  def  spd  spc

	.DB ROCK, FLYING ; type
	.DB 45 ; catch rate
	.DB 202 ; base exp

	.INCBIN "gfx/pokemon/front/aerodactyl.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW AerodactylPicFront, AerodactylPicBack

	.DB WING_ATTACK, AGILITY, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         DRAGON_RAGE,  MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         FIRE_BLAST,   SWIFT,        SKY_ATTACK,   \
	     REST,         SUBSTITUTE,   FLY
	; end

	.DB 0 ; padding
