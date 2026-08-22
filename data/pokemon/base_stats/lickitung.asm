	.DB DEX_LICKITUNG ; pokedex id

	.DB  90,  55,  75,  30,  60
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 45 ; catch rate
	.DB 127 ; base exp

	.INCBIN "gfx/pokemon/front/lickitung.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW LickitungPicFront, LickitungPicBack

	.DB WRAP, SUPERSONIC, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   SWORDS_DANCE, MEGA_KICK,    TOXIC,        BODY_SLAM,    \
	     TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     \
	     BLIZZARD,     HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         THUNDERBOLT,  THUNDER,      EARTHQUAKE,   FISSURE,      \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         FIRE_BLAST,   SKULL_BASH,   \
	     REST,         SUBSTITUTE,   CUT,          SURF,         STRENGTH
	; end

	.DB 0 ; padding
