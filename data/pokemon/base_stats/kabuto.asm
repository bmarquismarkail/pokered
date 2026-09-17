	.DB DEX_KABUTO ; pokedex id

	.DB  30,  80,  90,  55,  45
	;   hp  atk  def  spd  spc

	.DB ROCK, WATER ; type
	.DB 45 ; catch rate
	.DB 119 ; base exp

	.INCBIN "gfx/pokemon/front/kabuto.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW KabutoPicFront, KabutoPicBack

	.DB SCRATCH, HARDEN, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     RAGE,         MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         REST,         SUBSTITUTE,   \
	     SURF
	; end

	.DB 0 ; padding
