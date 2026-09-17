; TypeNames indexes (see data/types/names.asm)
	const_def

.DEFINE PHYSICAL const_value
	const NORMAL       ; $00
	const FIGHTING     ; $01
	const FLYING       ; $02
	const POISON       ; $03
	const GROUND       ; $04
	const ROCK         ; $05
	const BIRD         ; $06
	const BUG          ; $07
	const GHOST        ; $08

.DEFINE UNUSED_TYPES const_value
	const_next 20
.DEFINE UNUSED_TYPES_END const_value

.DEFINE SPECIAL const_value
	const FIRE         ; $14
	const WATER        ; $15
	const GRASS        ; $16
	const ELECTRIC     ; $17
	const PSYCHIC_TYPE ; $18
	const ICE          ; $19
	const DRAGON       ; $1A

.DEFINE NUM_TYPES const_value
