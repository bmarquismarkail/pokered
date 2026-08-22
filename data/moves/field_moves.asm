FieldMoveDisplayData:
	; move id, FieldMoveNames index, leftmost tile
	; (leftmost tile = -1 + tile column in which the first
	;  letter of the move's name should be displayed)
	.DB CUT,        1, $0C
	.DB FLY,        2, $0C
	.DB ANIM_B4,    3, $0C ; unused
	.DB SURF,       4, $0C
	.DB STRENGTH,   5, $0A
	.DB FLASH,      6, $0C
	.DB DIG,        7, $0C
	.DB TELEPORT,   8, $0A
	.DB SOFTBOILED, 9, $08
	.DB -1 ; end
