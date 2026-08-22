	.DB DEX_DUGTRIO ; pokedex id

	.DB  35,  80,  50, 120,  70
	;   hp  atk  def  spd  spc

	.DB GROUND, GROUND ; type
	.DB 50 ; catch rate
	.DB 153 ; base exp

	.INCBIN "gfx/pokemon/front/dugtrio.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW DugtrioPicFront, DugtrioPicBack

	.DB SCRATCH, GROWL, DIG, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	     RAGE,         EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         REST,         ROCK_SLIDE,   SUBSTITUTE
	; end

	.DB 0 ; padding
