	.DB DEX_CLEFABLE ; pokedex id

	.DB  95,  70,  73,  60,  85
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 25 ; catch rate
	.DB 129 ; base exp

	.INCBIN "gfx/pokemon/front/clefable.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ClefablePicFront, ClefablePicBack

	.DB SING, DOUBLESLAP, MINIMIZE, METRONOME ; level 1 learnset
	.DB GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     SOLARBEAM,    THUNDERBOLT,  THUNDER,      PSYCHIC_M,    TELEPORT,     \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         METRONOME,    \
	     FIRE_BLAST,   SKULL_BASH,   REST,         THUNDER_WAVE, PSYWAVE,      \
	     TRI_ATTACK,   SUBSTITUTE,   STRENGTH,     FLASH
	; end

	.DB 0 ; padding
