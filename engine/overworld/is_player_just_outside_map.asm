; returns whether the player is one tile outside the map in Z
IsPlayerJustOutsideMap:
	ld a, [wYCoord]
	ld b, a
	ld a, [wCurMapHeight]
	call IsPlayerJustOutsideMap.compareCoordWithMapDimension
	ret z
	ld a, [wXCoord]
	ld b, a
	ld a, [wCurMapWidth]
IsPlayerJustOutsideMap.compareCoordWithMapDimension
	add a
	cp b
	ret z
	inc b
	ret
