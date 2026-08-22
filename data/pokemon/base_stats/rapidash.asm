	.DB DEX_RAPIDASH ; pokedex id

	.DB  65, 100,  70, 105,  80
	;   hp  atk  def  spd  spc

	.DB FIRE, FIRE ; type
	.DB 60 ; catch rate
	.DB 192 ; base exp

	.INCBIN "gfx/pokemon/front/rapidash.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW RapidashPicFront, RapidashPicBack

	.DB EMBER, TAIL_WHIP, STOMP, GROWL ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   RAGE,         MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	     BIDE,         FIRE_BLAST,   SWIFT,        SKULL_BASH,   REST,         \
	     SUBSTITUTE
	; end

	.DB 0 ; padding
