	.DB DEX_VENONAT ; pokedex id

	.DB  60,  55,  50,  45,  40
	;   hp  atk  def  spd  spc

	.DB BUG, POISON ; type
	.DB 190 ; catch rate
	.DB 75 ; base exp

	.INCBIN "gfx/pokemon/front/venonat.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW VenonatPicFront, VenonatPicBack

	.DB TACKLE, DISABLE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  RAGE,         MEGA_DRAIN,   \
	     SOLARBEAM,    PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         REST,         PSYWAVE,      SUBSTITUTE
	; end

	.DB 0 ; padding
