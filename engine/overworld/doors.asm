; returns whether the player is standing on a door tile in carry
IsPlayerStandingOnDoorTile:
	push de
	ld hl, DoorTileIDPointers
	ld a, [wCurMapTileset]
	ld de, $3
	call IsInArray
	pop de
	jr nc, IsPlayerStandingOnDoorTile.notStandingOnDoor
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	lda_coord 8, 9 ; a = lower left background tile under player's sprite
	ld b, a
IsPlayerStandingOnDoorTile.loop
	ld a, [hli]
	and a
	jr z, IsPlayerStandingOnDoorTile.notStandingOnDoor
	cp b
	jr nz, IsPlayerStandingOnDoorTile.loop
	scf
	ret
IsPlayerStandingOnDoorTile.notStandingOnDoor
	and a
	ret

.INCLUDE "data/tilesets/door_tile_ids.asm"
