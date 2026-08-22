	.DB DEX_HITMONLEE ; pokedex id

	.DB  50, 120,  53,  87,  35
	;   hp  atk  def  spd  spc

	.DB FIGHTING, FIGHTING ; type
	.DB 45 ; catch rate
	.DB 139 ; base exp

	.INCBIN "gfx/pokemon/front/hitmonlee.pic" SKIP 0 READ 1 ; sprite dimensions
	.DW HitmonleePicFront, HitmonleePicBack

	.DB DOUBLE_KICK, MEDITATE, NO_MOVE, NO_MOVE ; level 1 learnset
	.DB GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     MIMIC,        DOUBLE_TEAM,  BIDE,         METRONOME,    SWIFT,        \
	     SKULL_BASH,   REST,         SUBSTITUTE,   STRENGTH
	; end

	.DB 0 ; padding
