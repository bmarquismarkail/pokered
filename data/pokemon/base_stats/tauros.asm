	.DB DEX_TAUROS ; pokedex id

	.DB  75, 100,  95, 110,  70
	;   hp  atk  def  spd  spc

	.DB NORMAL, NORMAL ; type
	.DB 45 ; catch rate
	.DB 211 ; base exp

	.INCBIN "gfx/pokemon/front/tauros.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW TaurosPicFront, TaurosPicBack

	.DB TACKLE, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     ICE_BEAM,     BLIZZARD,     HYPER_BEAM,   RAGE,         THUNDERBOLT,  \
	     THUNDER,      EARTHQUAKE,   FISSURE,      MIMIC,        DOUBLE_TEAM,  \
	     BIDE,         FIRE_BLAST,   SKULL_BASH,   REST,         SUBSTITUTE,   \
	     STRENGTH
	; end

	.DB 0 ; padding
