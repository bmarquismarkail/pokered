	.DB DEX_VOLTORB ; pokedex id

	.DB  40,  30,  50, 100,  55
	;   hp  atk  def  spd  spc

	.DB ELECTRIC, ELECTRIC ; type
	.DB 190 ; catch rate
	.DB 103 ; base exp

	.INCBIN "gfx/pokemon/front/voltorb.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW VoltorbPicFront, VoltorbPicBack

	.DB TACKLE, SCREECH, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    RAGE,         THUNDERBOLT,  THUNDER,      \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         \
	     SELFDESTRUCT, SWIFT,        REST,         THUNDER_WAVE, EXPLOSION,    \
	     SUBSTITUTE,   FLASH
	; end

	.DB 0 ; padding
