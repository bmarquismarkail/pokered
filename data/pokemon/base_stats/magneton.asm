	.DB DEX_MAGNETON ; pokedex id

	.DB  50,  60,  95,  70, 120
	;   hp  atk  def  spd  spc

	.DB ELECTRIC, ELECTRIC ; type
	.DB 60 ; catch rate
	.DB 161 ; base exp

	.INCBIN "gfx/pokemon/front/magneton.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MagnetonPicFront, MagnetonPicBack

	.DB TACKLE, SONICBOOM, THUNDERSHOCK, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   RAGE,         \
	     THUNDERBOLT,  THUNDER,      TELEPORT,     MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      BIDE,         SWIFT,        REST,         THUNDER_WAVE, \
	     SUBSTITUTE,   FLASH
	; end

	.DB 0 ; padding
