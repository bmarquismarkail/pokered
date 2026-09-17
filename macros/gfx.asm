.MACRO RGB
	.REPT NARGS / 3
		.DW ((\1) << B_COLOR_RED) + ((\2) << B_COLOR_GREEN) + ((\3) << B_COLOR_BLUE)
		.SHIFT
		.SHIFT
		.SHIFT
	.ENDR
.ENDM

.MACRO dbsprite
; x tile, y tile, x pixel, y pixel, vtile offset, attributes
	.DB (\2 * TILE_WIDTH) # $100 + \4, (\1 * TILE_WIDTH) # $100 + \3, \5, \6
.ENDM
