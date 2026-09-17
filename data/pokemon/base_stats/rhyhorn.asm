	.DB DEX_RHYHORN ; pokedex id

	.DB  80,  85,  95,  25,  30
	;   hp  atk  def  spd  spc

	.DB GROUND, ROCK ; type
	.DB 120 ; catch rate
	.DB 135 ; base exp

	.INCBIN "gfx/pokemon/front/rhyhorn.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW RhyhornPicFront, RhyhornPicBack

	.DB HORN_ATTACK, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     RAGE,         THUNDERBOLT,  THUNDER,      EARTHQUAKE,   FISSURE,      \
	     DIG,          MIMIC,        DOUBLE_TEAM,  BIDE,         FIRE_BLAST,   \
	     SKULL_BASH,   REST,         ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
