	.DB DEX_STARMIE ; pokedex id

	.DB  60,  75,  85, 115, 100
	;   hp  atk  def  spd  spc

	.DB WATER, PSYCHIC_TYPE ; type
	.DB 60 ; catch rate
	.DB 207 ; base exp

	.INCBIN "gfx/pokemon/front/starmie.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW StarmiePicFront, StarmiePicBack

	.DB TACKLE, WATER_GUN, HARDEN, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    \
	     ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         THUNDERBOLT,  \
	     THUNDER,      PSYCHIC_M,    TELEPORT,     MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         SWIFT,        SKULL_BASH,   REST,         \
	     THUNDER_WAVE, PSYWAVE,      TRI_ATTACK,   SUBSTITUTE,   SURF,         \
	     FLASH
	; end

	.DB 0 ; padding
