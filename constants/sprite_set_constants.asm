; sprite set ids
; indexes for SpriteSets (see data/maps/sprite_sets.asm)
; values for MapSpriteSets and SplitMapSpriteSets (see data/maps/sprite_sets.asm)
	const_def 1
	const SPRITESET_PALLET_VIRIDIAN ; 01
	const SPRITESET_PEWTER_CERULEAN ; 02
	const SPRITESET_LAVENDER        ; 03
	const SPRITESET_VERMILION       ; 04
	const SPRITESET_CELADON         ; 05
	const SPRITESET_INDIGO          ; 06
	const SPRITESET_SAFFRON         ; 07
	const SPRITESET_SILENCE_BRIDGE  ; 08
	const SPRITESET_CYCLING_ROAD    ; 09
	const SPRITESET_FUCHSIA         ; 0a
.DEFINE NUM_SPRITE_SETS const_value - 1

; split sprite set ids
; indexes for SplitMapSpriteSets (see data/maps/sprite_sets.asm)
; values for MapSpriteSets (see data/maps/sprite_sets.asm)
	const_next $f1
.DEFINE FIRST_SPLIT_SET const_value
	const SPLITSET_ROUTE_2  ; f1
	const SPLITSET_ROUTE_10 ; f2
	const SPLITSET_ROUTE_11 ; f3
	const SPLITSET_ROUTE_12 ; f4
	const SPLITSET_ROUTE_15 ; f5
	const SPLITSET_ROUTE_16 ; f6
	const SPLITSET_ROUTE_18 ; f7
	const SPLITSET_ROUTE_20 ; f8
	const SPLITSET_ROUTE_5  ; f9
	const SPLITSET_ROUTE_6  ; fa
	const SPLITSET_ROUTE_7  ; fb
	const SPLITSET_ROUTE_8  ; fc
.DEFINE NUM_SPLIT_SETS const_value - FIRST_SPLIT_SET

; split directions
.DEFINE EAST_WEST 1
.DEFINE NORTH_SOUTH 2

; each sprite set has 9 walking sprites and 2 still sprites
.DEFINE SPRITE_SET_LENGTH 9 + 2
