	.DB DEX_PARASECT ; pokedex id

	.DB  60,  95,  80,  30,  80
	;   hp  atk  def  spd  spc

	.DB BUG, GRASS ; type
	.DB 75 ; catch rate
	.DB 128 ; base exp

	.INCBIN "gfx/pokemon/front/parasect.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ParasectPicFront, ParasectPicBack

	.DB SCRATCH, STUN_SPORE, LEECH_LIFE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MEGA_DRAIN,   SOLARBEAM,    DIG,          \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SKULL_BASH,   \
	     REST,         SUBSTITUTE,   CUT
	; end

	.DB 0 ; padding
