	.DB DEX_EXEGGUTOR ; pokedex id

	.DB  95,  95,  85,  55, 125
	;   hp  atk  def  spd  spc

	.DB GRASS, PSYCHIC_TYPE ; type
	.DB 45 ; catch rate
	.DB 212 ; base exp

	.INCBIN "gfx/pokemon/front/exeggutor.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ExeggutorPicFront, ExeggutorPicBack

	.DB BARRAGE, HYPNOSIS, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   RAGE,         \
	     MEGA_DRAIN,   SOLARBEAM,    PSYCHIC_M,    TELEPORT,     MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         SELFDESTRUCT, EGG_BOMB,     \
	     REST,         PSYWAVE,      EXPLOSION,    SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
