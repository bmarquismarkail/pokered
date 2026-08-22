	.DB DEX_KANGASKHAN ; pokedex id

	.DB 105,  95,  80,  90,  40
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 45 ; catch rate
	.DB 175 ; base exp

	.INCBIN "gfx/pokemon/front/kangaskhan.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW KangaskhanPicFront, KangaskhanPicBack

	.DB COMET_PUNCH, RAGE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     THUNDERBOLT,  THUNDER,      EARTHQUAKE,   FISSURE,      MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         FIRE_BLAST,   SKULL_BASH,   REST,         \
	     ROCK_SLIDE,   SUBSTITUTE,   SURF,         STRENGTH
	; end

	.DB 0 ; padding
