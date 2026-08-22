	.DB DEX_PIKACHU ; pokedex id

	.DB  35,  55,  30,  90,  50
	;   hp  atk  def  spd  spc

	.DB ELECTRIC, ELECTRIC ; type
	.DB 190 ; catch rate
	.DB 82 ; base exp

	.INCBIN "gfx/pokemon/front/pikachu.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW PikachuPicFront, PikachuPicBack

	.DB THUNDERSHOCK, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  PAY_DAY,      SUBMISSION,   SEISMIC_TOSS, RAGE,         \
	     THUNDERBOLT,  THUNDER,      MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SWIFT,        SKULL_BASH,   REST,         THUNDER_WAVE, \
	     SUBSTITUTE,   FLASH
	; end

	.DB 0 ; padding
