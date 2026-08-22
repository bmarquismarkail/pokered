	.DB DEX_KADABRA ; pokedex id

	.DB  40,  35,  30, 105, 120
	;   hp  atk  def  spd  spc

	.DB PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	.DB 100 ; catch rate
	.DB 145 ; base exp

	.INCBIN "gfx/pokemon/front/kadabra.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW KadabraPicFront, KadabraPicBack

	.DB TELEPORT, CONFUSION, DISABLE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     DIG,          PSYCHIC_M,    TELEPORT,     MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         METRONOME,    SKULL_BASH,   REST,         \
	     THUNDER_WAVE, PSYWAVE,      TRI_ATTACK,   SUBSTITUTE,   FLASH
	; end

	.DB 0 ; padding
