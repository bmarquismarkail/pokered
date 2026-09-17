.MACRO validate_coords
	.IF NARGS >= 4
		.IF \1 >= \3
			.FAIL "x coord out of range"
		.ENDIF
		.IF \2 >= \4
			.FAIL "y coord out of range"
		.ENDIF
	.ELSE
		validate_coords \1, \2, SCREEN_WIDTH, SCREEN_HEIGHT
	.ENDIF
.ENDM

.MACRO hlcoord
	.IF NARGS >= 3
		coord "hl", \1, \2, \3
	.ELSE
		coord "hl", \1, \2
	.ENDIF
.ENDM

.MACRO bccoord
	.IF NARGS >= 3
		coord "bc", \1, \2, \3
	.ELSE
		coord "bc", \1, \2
	.ENDIF
.ENDM

.MACRO decoord
	.IF NARGS >= 3
		coord "de", \1, \2, \3
	.ELSE
		coord "de", \1, \2
	.ENDIF
.ENDM

.MACRO coord
; register, x, y[, origin]
	validate_coords \2, \3
	.IF NARGS >= 4
		ld \1, (\3) * SCREEN_WIDTH + (\2) + \4
	.ELSE
		ld \1, (\3) * SCREEN_WIDTH + (\2) + wTileMap
	.ENDIF
.ENDM

.MACRO hlbgcoord
	.IF NARGS >= 3
		bgcoord "hl", \1, \2, \3
	.ELSE
		bgcoord "hl", \1, \2
	.ENDIF
.ENDM

.MACRO bcbgcoord
	.IF NARGS >= 3
		bgcoord "bc", \1, \2, \3
	.ELSE
		bgcoord "bc", \1, \2
	.ENDIF
.ENDM

.MACRO debgcoord
	.IF NARGS >= 3
		bgcoord "de", \1, \2, \3
	.ELSE
		bgcoord "de", \1, \2
	.ENDIF
.ENDM

.MACRO bgcoord
; register, x, y[, origin]
	validate_coords \2, \3, TILEMAP_WIDTH, TILEMAP_HEIGHT
	.IF NARGS >= 4
		ld \1, (\3) * TILEMAP_WIDTH + (\2) + \4
	.ELSE
		ld \1, (\3) * TILEMAP_WIDTH + (\2) + vBGMap0
	.ENDIF
.ENDM

.MACRO hlowcoord
	owcoord "hl", \1, \2, \3
.ENDM

.MACRO bcowcoord
	owcoord "bc", \1, \2, \3
.ENDM

.MACRO deowcoord
	owcoord "de", \1, \2, \3
.ENDM

.MACRO owcoord
; register, x, y, map width
	ld \1, wOverworldMap + ((\2) + 3) + (((\3) + 3) * ((\4) + (3 * 2)))
.ENDM

.MACRO event_displacement
; map width, x blocks, y blocks
	.DW (wOverworldMap + 7 + (\1) + ((\1) + 6) * ((\3) >> 1) + ((\2) >> 1))
	.DB \3, \2
.ENDM

.MACRO dwcoord
; x, y
	validate_coords \1, \2
	.IF NARGS >= 3
		.DW (\2) * SCREEN_WIDTH + (\1) + \3
	.ELSE
		.DW (\2) * SCREEN_WIDTH + (\1) + wTileMap
	.ENDIF
.ENDM

.MACRO ldcoord_a
; x, y[, origin]
	validate_coords \1, \2
	.IF NARGS >= 3
		ld [(\2) * SCREEN_WIDTH + (\1) + \3], a
	.ELSE
		ld [(\2) * SCREEN_WIDTH + (\1) + wTileMap], a
	.ENDIF
.ENDM

.MACRO lda_coord
; x, y[, origin]
	validate_coords \1, \2
	.IF NARGS >= 3
		ld a, [(\2) * SCREEN_WIDTH + (\1) + \3]
	.ELSE
		ld a, [(\2) * SCREEN_WIDTH + (\1) + wTileMap]
	.ENDIF
.ENDM

.MACRO dbmapcoord
; x, y
	.DB \2, \1
.ENDM
