	.DB DEX_GOLDUCK ; pokedex id

	.DB  80,  82,  78,  85,  80
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 75 ; catch rate
	.DB 174 ; base exp

	.INCBIN "gfx/pokemon/front/golduck.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW GolduckPicFront, GolduckPicBack

	.DB SCRATCH, TAIL_WHIP, DISABLE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   PAY_DAY,      SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     RAGE,         DIG,          MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     SWIFT,        SKULL_BASH,   REST,         SUBSTITUTE,   SURF,         \
	     STRENGTH
	; end

	.DB 0 ; padding
