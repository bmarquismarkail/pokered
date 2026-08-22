	.DB DEX_SLOWPOKE ; pokedex id

	.DB  90,  65,  65,  15,  40
	;   hp  atk  def  spd  spc

	.DB WATER, PSYCHIC_TYPE ; type
	.DB 190 ; catch rate
	.DB 99 ; base exp

	.INCBIN "gfx/pokemon/front/slowpoke.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW SlowpokePicFront, SlowpokePicBack

	.DB CONFUSION, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     PAY_DAY,      RAGE,         \
	     EARTHQUAKE,   FISSURE,      DIG,          PSYCHIC_M,    TELEPORT,     \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         FIRE_BLAST,   \
	     SWIFT,        SKULL_BASH,   REST,         THUNDER_WAVE, PSYWAVE,      \
	     TRI_ATTACK,   SUBSTITUTE,   SURF,         STRENGTH,     FLASH
	; end

	.DB 0 ; padding
