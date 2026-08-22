	.DB DEX_PSYDUCK ; pokedex id

	.DB  50,  52,  48,  55,  50
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 190 ; catch rate
	.DB 80 ; base exp

	.INCBIN "gfx/pokemon/front/psyduck.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PsyduckPicFront, PsyduckPicBack

	.DB SCRATCH, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     PAY_DAY,      SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     DIG,          MIMIC,        DOUBLE_TEAM,  BIDE,         SWIFT,        \
	     SKULL_BASH,   REST,         SUBSTITUTE,   SURF,         STRENGTH
	; end

	.DB 0 ; padding
