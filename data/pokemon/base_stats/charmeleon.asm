	.DB DEX_CHARMELEON ; pokedex id

	.DB  58,  64,  58,  80,  65
	;   hp  atk  def  spd  spc

	.DB FIRE, FIRE ; type
	.DB 45 ; catch rate
	.DB 142 ; base exp

	.INCBIN "gfx/pokemon/front/charmeleon.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW CharmeleonPicFront, CharmeleonPicBack

	.DB SCRATCH, GROWL, EMBER, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   SWORDS_DANCE, MEGA_KICK,    TOXIC,        BODY_SLAM,    \
	     TAKE_DOWN,    DOUBLE_EDGE,  SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         DRAGON_RAGE,  DIG,          MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         FIRE_BLAST,   SWIFT,        SKULL_BASH,   \
	     REST,         SUBSTITUTE,   CUT,          STRENGTH
	; end

	.DB 0 ; padding
