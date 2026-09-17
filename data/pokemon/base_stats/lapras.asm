	.DB DEX_LAPRAS ; pokedex id

	.DB 130,  85,  80,  60,  95
	;   hp  atk  def  spd  spc

	.DB WATER, ICE ; type
	.DB 45 ; catch rate
	.DB 219 ; base exp

	.INCBIN "gfx/pokemon/front/lapras.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW LaprasPicFront, LaprasPicBack

	.DB WATER_GUN, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   \
	     RAGE,         SOLARBEAM,    DRAGON_RAGE,  THUNDERBOLT,  THUNDER,      \
	     PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SKULL_BASH,   REST,         PSYWAVE,      SUBSTITUTE,   SURF,         \
	     STRENGTH
	; end

	.DB 0 ; padding
