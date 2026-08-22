	.DB DEX_MAGNEMITE ; pokedex id

	.DB  25,  35,  70,  45,  95
	;   hp  atk  def  spd  spc

	.DB ELECTRIC, ELECTRIC ; type
	.DB 190 ; catch rate
	.DB 89 ; base exp

	.INCBIN "gfx/pokemon/front/magnemite.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW MagnemitePicFront, MagnemitePicBack

	.DB TACKLE, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         THUNDERBOLT,  \
	     THUNDER,      TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         SWIFT,        REST,         THUNDER_WAVE, SUBSTITUTE,   \
	     FLASH
	; end

	.DB 0 ; padding
