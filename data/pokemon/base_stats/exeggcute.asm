	.DB DEX_EXEGGCUTE ; pokedex id

	.DB  60,  40,  80,  40,  60
	;   hp  atk  def  spd  spc

	.DB GRASS, PSYCHIC_TYPE ; type
	.DB 90 ; catch rate
	.DB 98 ; base exp

	.INCBIN "gfx/pokemon/front/exeggcute.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ExeggcutePicFront, ExeggcutePicBack

	.DB BARRAGE, HYPNOSIS, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         PSYCHIC_M,    \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SELFDESTRUCT, EGG_BOMB,     REST,         PSYWAVE,      EXPLOSION,    \
	     SUBSTITUTE
	; end

	.DB 0 ; padding
