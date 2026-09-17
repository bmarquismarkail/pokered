	.DB DEX_DIGLETT ; pokedex id

	.DB  10,  55,  25,  95,  45
	;   hp  atk  def  spd  spc

	.DB GROUND, GROUND ; type
	.DB 255 ; catch rate
	.DB 81 ; base exp

	.INCBIN "gfx/pokemon/front/diglett.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW DiglettPicFront, DiglettPicBack

	.DB SCRATCH, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         \
	     EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         REST,         ROCK_SLIDE,   SUBSTITUTE
	; end

	.DB 0 ; padding
