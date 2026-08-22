LoadTilesetHeader:
	call GetPredefRegisters
	push hl
	ld d, 0
	ld a, [wCurMapTileset]
	add a
	add a
	ld b, a
	add a
	add b ; a = tileset * 12
	jr nc, LoadTilesetHeader.noCarry
	inc d
LoadTilesetHeader.noCarry
	ld e, a
	ld hl, Tilesets
	add hl, de
	ld de, wTilesetBank
	ld c, $b
LoadTilesetHeader.copyTilesetHeaderLoop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, LoadTilesetHeader.copyTilesetHeaderLoop
	ld a, [hl]
	ldh [lobyte(hTileAnimations)], a
	xor a
	ldh [lobyte(hMovingBGTilesCounter1)], a
	pop hl
	ld a, [wCurMapTileset]
	push hl
	push de
	ld hl, DungeonTilesets
	ld de, $1
	call IsInArray
	pop de
	pop hl
	jr c, LoadTilesetHeader.dungeon
	ld a, [wCurMapTileset]
	ld b, a
	ldh a, [lobyte(hPreviousTileset)]
	cp b
	jr z, LoadTilesetHeader.done
LoadTilesetHeader.dungeon
	ld a, [wDestinationWarpID]
	cp $ff
	jr z, LoadTilesetHeader.done
	call LoadDestinationWarpPosition
	ld a, [wYCoord]
	and $1
	ld [wYBlockCoord], a
	ld a, [wXCoord]
	and $1
	ld [wXBlockCoord], a
LoadTilesetHeader.done
	ret

.INCLUDE "data/tilesets/dungeon_tilesets.asm"

.INCLUDE "data/tilesets/tileset_headers.asm"
