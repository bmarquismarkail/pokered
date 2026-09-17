WarpTileListPointers:
	.DW WarpTileListPointers.FacingDownWarpTiles
	.DW WarpTileListPointers.FacingUpWarpTiles
	.DW WarpTileListPointers.FacingLeftWarpTiles
	.DW WarpTileListPointers.FacingRightWarpTiles

.MACRO warp_carpet_tiles
	.REPT NARGS
		.DB \1 ; all args
		.SHIFT
	.ENDR
	.DB -1 ; end
.ENDM

WarpTileListPointers.FacingDownWarpTiles:
	warp_carpet_tiles $01, $12, $17, $3D, $04, $18, $33

WarpTileListPointers.FacingUpWarpTiles:
	warp_carpet_tiles $01, $5C

WarpTileListPointers.FacingLeftWarpTiles:
	warp_carpet_tiles $1A, $4B

WarpTileListPointers.FacingRightWarpTiles:
	warp_carpet_tiles $0F, $4E
