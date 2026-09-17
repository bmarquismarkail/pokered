	.DB DEX_PORYGON ; pokedex id

	.DB  65,  60,  70,  40,  75
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 45 ; catch rate
	.DB 130 ; base exp

	.INCBIN "gfx/pokemon/front/porygon.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PorygonPicFront, PorygonPicBack

	.DB TACKLE, SHARPEN, CONVERSION, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   RAGE,         THUNDERBOLT,  THUNDER,      PSYCHIC_M,    \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SWIFT,        SKULL_BASH,   REST,         THUNDER_WAVE, PSYWAVE,      \
	     TRI_ATTACK,   SUBSTITUTE,   FLASH
	; end

	.DB 0 ; padding
