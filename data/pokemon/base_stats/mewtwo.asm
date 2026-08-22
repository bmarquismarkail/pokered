	.DB DEX_MEWTWO ; pokedex id

	.DB 106, 110,  90, 130, 154
	;   hp  atk  def  spd  spc

	.DB PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	.DB 3 ; catch rate
	.DB 220 ; base exp

	.INCBIN "gfx/pokemon/front/mewtwo.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MewtwoPicFront, MewtwoPicBack

	.DB CONFUSION, DISABLE, SWIFT, PSYCHIC_M ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   PAY_DAY,      SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         SOLARBEAM,    THUNDERBOLT,  THUNDER,      PSYCHIC_M,    \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     METRONOME,    SELFDESTRUCT, FIRE_BLAST,   SKULL_BASH,   REST,         \
	     THUNDER_WAVE, PSYWAVE,      TRI_ATTACK,   SUBSTITUTE,   STRENGTH,     \
	     FLASH
	; end

	.DB 0 ; padding
