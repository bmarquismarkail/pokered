	.DB DEX_JIGGLYPUFF ; pokedex id

	.DB 115,  45,  20,  20,  25
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 170 ; catch rate
	.DB 76 ; base exp

	.INCBIN "gfx/pokemon/front/jigglypuff.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW JigglypuffPicFront, JigglypuffPicBack

	.DB SING, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         SOLARBEAM,    \
	     THUNDERBOLT,  THUNDER,      PSYCHIC_M,    TELEPORT,     MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         FIRE_BLAST,   SKULL_BASH,   \
	     REST,         THUNDER_WAVE, PSYWAVE,      TRI_ATTACK,   SUBSTITUTE,   \
	     STRENGTH,     FLASH
	; end

	.DB 0 ; padding
