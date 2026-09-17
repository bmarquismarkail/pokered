	.DB DEX_ELECTRODE ; pokedex id

	.DB  60,  50,  70, 140,  80
	;   hp  atk  def  spd  spc

	.DB ELECTRIC, ELECTRIC ; type
	.DB 60 ; catch rate
	.DB 150 ; base exp

	.INCBIN "gfx/pokemon/front/electrode.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ElectrodePicFront, ElectrodePicBack

	.DB TACKLE, SCREECH, SONICBOOM, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    HYPER_BEAM,   RAGE,         THUNDERBOLT,  \
	     THUNDER,      TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SELFDESTRUCT, SWIFT,        SKULL_BASH,   REST,         \
	     THUNDER_WAVE, EXPLOSION,    SUBSTITUTE,   FLASH
	; end

	.DB 0 ; padding
