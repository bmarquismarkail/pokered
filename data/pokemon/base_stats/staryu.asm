	.DB DEX_STARYU ; pokedex id

	.DB  30,  45,  55,  85,  70
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 225 ; catch rate
	.DB 106 ; base exp

	.INCBIN "gfx/pokemon/front/staryu.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW StaryuPicFront, StaryuPicBack

	.DB TACKLE, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    \
	     ICE_BEAM,     BLIZZARD,     RAGE,         THUNDERBOLT,  THUNDER,      \
	     PSYCHIC_M,    TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SWIFT,        SKULL_BASH,   REST,         THUNDER_WAVE, \
	     PSYWAVE,      TRI_ATTACK,   SUBSTITUTE,   SURF,         FLASH
	; end

	.DB 0 ; padding
