	.DB DEX_SHELLDER ; pokedex id

	.DB  30,  65, 100,  40,  45
	;   hp  atk  def  spd  spc

	.DB WATER, WATER ; type
	.DB 190 ; catch rate
	.DB 97 ; base exp

	.INCBIN "gfx/pokemon/front/shellder.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW ShellderPicFront, ShellderPicBack

	.DB TACKLE, WITHDRAW, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    \
	     ICE_BEAM,     BLIZZARD,     RAGE,         TELEPORT,     MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,      BIDE,         SELFDESTRUCT, SWIFT,        \
	     REST,         EXPLOSION,    TRI_ATTACK,   SUBSTITUTE,   SURF
	; end

	.DB 0 ; padding
