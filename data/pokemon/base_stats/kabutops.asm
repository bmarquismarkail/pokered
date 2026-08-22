	.DB DEX_KABUTOPS ; pokedex id

	.DB  60, 115, 105,  80,  70
	;   hp  atk  def  spd  spc

	.DB ROCK, WATER ; type
	.DB 45 ; catch rate
	.DB 201 ; base exp

	.INCBIN "gfx/pokemon/front/kabutops.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW KabutopsPicFront, KabutopsPicBack

	.DB SCRATCH, HARDEN, ABSORB, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm RAZOR_WIND,   SWORDS_DANCE, MEGA_KICK,    TOXIC,        BODY_SLAM,    \
	     TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     \
	     BLIZZARD,     HYPER_BEAM,   SUBMISSION,   SEISMIC_TOSS, RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SKULL_BASH,   \
	     REST,         SUBSTITUTE,   SURF
	; end

	.DB 0 ; padding
