	.DB DEX_CLOYSTER ; pokedex id

	.DB  50,  95, 180,  70,  85
	;   hp  atk  def  spd  spc

	.DB WATER, ICE ; type
	.DB 60 ; catch rate
	.DB 203 ; base exp

	.INCBIN "gfx/pokemon/front/cloyster.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW CloysterPicFront, CloysterPicBack

	.DB WITHDRAW, SUPERSONIC, CLAMP, AURORA_BEAM ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    \
	     ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         TELEPORT,     \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         SELFDESTRUCT, \
	     SWIFT,        REST,         EXPLOSION,    TRI_ATTACK,   SUBSTITUTE,   \
	     SURF
	; end

	.DB 0 ; padding
