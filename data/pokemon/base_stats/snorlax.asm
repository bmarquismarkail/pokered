	.DB DEX_SNORLAX ; pokedex id

	.DB 160, 110,  65,  30,  65
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 25 ; catch rate
	.DB 154 ; base exp

	.INCBIN "gfx/pokemon/front/snorlax.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW SnorlaxPicFront, SnorlaxPicBack

	.DB HEADBUTT, AMNESIA, REST, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   PAY_DAY,      SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         SOLARBEAM,    THUNDERBOLT,  THUNDER,      EARTHQUAKE,   \
	     FISSURE,      PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         METRONOME,    SELFDESTRUCT, FIRE_BLAST,   SKULL_BASH,   \
	     REST,         PSYWAVE,      ROCK_SLIDE,   SUBSTITUTE,   SURF,         \
	     STRENGTH
	; end

	.DB 0 ; padding
