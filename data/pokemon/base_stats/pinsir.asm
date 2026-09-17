	.DB DEX_PINSIR ; pokedex id

	.DB  65, 125, 100,  85,  55
	;   hp  atk  def  spd  spc

	.DB BUG, BUG ; type
	.DB 45 ; catch rate
	.DB 200 ; base exp

	.INCBIN "gfx/pokemon/front/pinsir.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PinsirPicFront, PinsirPicBack

	.DB VICEGRIP, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   SUBMISSION,   SEISMIC_TOSS, RAGE,         MIMIC,        \
	     DOUBLE_TEAM,  BIDE,         REST,         SUBSTITUTE,   CUT,          \
	     STRENGTH
	; end

	.DB 0 ; padding
