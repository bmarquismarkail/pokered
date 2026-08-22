	.DB DEX_CHANSEY ; pokedex id

	.DB 250,   5,   5,  50, 105
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 30 ; catch rate
	.DB 255 ; base exp

	.INCBIN "gfx/pokemon/front/chansey.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ChanseyPicFront, ChanseyPicBack

	.DB POUND, DOUBLESLAP, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     SOLARBEAM,    THUNDERBOLT,  THUNDER,      PSYCHIC_M,    TELEPORT,     \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         METRONOME,    \
	     EGG_BOMB,     FIRE_BLAST,   SKULL_BASH,   SOFTBOILED,   REST,         \
	     THUNDER_WAVE, PSYWAVE,      TRI_ATTACK,   SUBSTITUTE,   STRENGTH,     \
	     FLASH
	; end

	.DB 0 ; padding
