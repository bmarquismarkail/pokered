	.DB DEX_CHARIZARD ; pokedex id

	.DB  78,  84,  78, 100,  85
	;   hp  atk  def  spd  spc

	.DB FIRE, FLYING ; type
	.DB 45 ; catch rate
	.DB 209 ; base exp

	.INCBIN "gfx/pokemon/front/charizard.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW CharizardPicFront, CharizardPicBack

	.DB SCRATCH, GROWL, EMBER, LEER ; level 1 learnset
	.DB GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   SWORDS_DANCE, MEGA_KICK,    TOXIC,        BODY_SLAM,    \
	     TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      \
	     SEISMIC_TOSS, RAGE,         DRAGON_RAGE,  EARTHQUAKE,   FISSURE,      \
	     DIG,          MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     FIRE_BLAST,   SWIFT,        SKULL_BASH,   REST,         SUBSTITUTE,   \
	     CUT,          STRENGTH
	; end

	.DB 0 ; padding
