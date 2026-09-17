; this function seems to be used only once
; it store the address of a row and column of the VRAM background map in hl
; INPUT: h - row, l - column, b - high byte of background tile map address in VRAM
GetRowColAddressBgMap:
	xor a
	srl h
	rr a
	srl h
	rr a
	srl h
	rr a
	or l
	ld l, a
	ld a, b
	or h
	ld h, a
	ret

; clears a VRAM background map with blank space tiles
; INPUT: h - high byte of background tile map address in VRAM
ClearBgMap:
	ld a, $7f
	jr FillBgMapCommon

; fills a VRAM background map with tile index in register l
; INPUT: h - high byte of background tile map address in VRAM
FillBgMap: ; unreferenced
	ld a, l

FillBgMapCommon:
	ld de, TILEMAP_AREA
	ld l, e
FillBgMapCommon.loop
	ld [hli], a
	dec e
	jr nz, FillBgMapCommon.loop
	dec d
	jr nz, FillBgMapCommon.loop
	ret

; This function redraws a BG row of height 2 or a BG column of width 2.
; One of its main uses is redrawing the row or column that will be exposed upon
; scrolling the BG when the player takes a step. Redrawing only the exposed
; row or column is more efficient than redrawing the entire screen.
; However, this function is also called repeatedly to redraw the whole screen
; when necessary. It is also used in trade animation and elevator code.
RedrawRowOrColumn:
	ldh a, [lobyte(hRedrawRowOrColumnMode)]
	and a
	ret z
	ld b, a
	xor a
	ldh [lobyte(hRedrawRowOrColumnMode)], a
	dec b
	jr nz, RedrawRowOrColumn.redrawRow
RedrawRowOrColumn.redrawColumn
	ld hl, wRedrawRowOrColumnSrcTiles
	ldh a, [lobyte(hRedrawRowOrColumnDest)]
	ld e, a
	ldh a, [lobyte(hRedrawRowOrColumnDest + 1)]
	ld d, a
	ld c, SCREEN_HEIGHT
RedrawRowOrColumn.loop1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, TILEMAP_WIDTH - 1
	add e
	ld e, a
	jr nc, RedrawRowOrColumn.noCarry
	inc d
RedrawRowOrColumn.noCarry
; the following 4 lines wrap us from bottom to top if necessary
	ld a, d
	and hibyte(TILEMAP_AREA - 1)
	or hibyte(vBGMap0)
	ld d, a
	dec c
	jr nz, RedrawRowOrColumn.loop1
	xor a
	ldh [lobyte(hRedrawRowOrColumnMode)], a
	ret
RedrawRowOrColumn.redrawRow
	ld hl, wRedrawRowOrColumnSrcTiles
	ldh a, [lobyte(hRedrawRowOrColumnDest)]
	ld e, a
	ldh a, [lobyte(hRedrawRowOrColumnDest + 1)]
	ld d, a
	push de
	call RedrawRowOrColumn.DrawHalf ; draw upper half
	pop de
	ld a, TILEMAP_WIDTH
	add e
	ld e, a
	; fall through and draw lower half

RedrawRowOrColumn.DrawHalf
	ld c, SCREEN_WIDTH / 2
RedrawRowOrColumn.loop2
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, e
	inc a
; the following 6 lines wrap us from the right edge to the left edge if necessary
	and %11111
	ld b, a
	ld a, e
	and %11100000
	or b
	ld e, a
	dec c
	jr nz, RedrawRowOrColumn.loop2
	ret

; This function automatically transfers tile number data from the tile map at
; wTileMap to VRAM during V-blank. Note that it only transfers one third of the
; background per V-blank. It cycles through which third it draws.
; This transfer is turned off when walking around the map, but is turned
; on when talking to sprites, battling, using menus, etc. This is because
; the above function, RedrawRowOrColumn, is used when walking to
; improve efficiency.
AutoBgMapTransfer:
	ldh a, [lobyte(hAutoBGTransferEnabled)]
	and a
	ret z
	ld hl, sp+0
	ld a, h
	ldh [lobyte(hSPTemp)], a
	ld a, l
	ldh [lobyte(hSPTemp + 1)], a ; save stack pointer
	ldh a, [lobyte(hAutoBGTransferPortion)]
	and a
	jr z, AutoBgMapTransfer.transferTopThird
	dec a
	jr z, AutoBgMapTransfer.transferMiddleThird
AutoBgMapTransfer.transferBottomThird
	hlcoord 0, 2 * SCREEN_HEIGHT / 3
	ld sp, hl
	ldh a, [lobyte(hAutoBGTransferDest + 1)]
	ld h, a
	ldh a, [lobyte(hAutoBGTransferDest)]
	ld l, a
	ld de, 12 * TILEMAP_WIDTH
	add hl, de
	xor a ; TRANSFERTOP
	jr AutoBgMapTransfer.doTransfer
AutoBgMapTransfer.transferTopThird
	hlcoord 0, 0
	ld sp, hl
	ldh a, [lobyte(hAutoBGTransferDest + 1)]
	ld h, a
	ldh a, [lobyte(hAutoBGTransferDest)]
	ld l, a
	ld a, TRANSFERMIDDLE
	jr AutoBgMapTransfer.doTransfer
AutoBgMapTransfer.transferMiddleThird
	hlcoord 0, SCREEN_HEIGHT / 3
	ld sp, hl
	ldh a, [lobyte(hAutoBGTransferDest + 1)]
	ld h, a
	ldh a, [lobyte(hAutoBGTransferDest)]
	ld l, a
	ld de, 6 * TILEMAP_WIDTH
	add hl, de
	ld a, TRANSFERBOTTOM
AutoBgMapTransfer.doTransfer
	ldh [lobyte(hAutoBGTransferPortion)], a ; store next portion
	ld b, SCREEN_HEIGHT / 3

TransferBgRows:
; unrolled loop and using pop for speed
.REPT SCREEN_WIDTH / 2 - 1
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
.ENDR
	pop de
	ld [hl], e
	inc l
	ld [hl], d

	ld a, TILEMAP_WIDTH - (SCREEN_WIDTH - 1)
	add l
	ld l, a
	jr nc, TransferBgRows.ok
	inc h
TransferBgRows.ok
	dec b
	jr nz, TransferBgRows

	ldh a, [lobyte(hSPTemp)]
	ld h, a
	ldh a, [lobyte(hSPTemp + 1)]
	ld l, a
	ld sp, hl
	ret

; Copies [hVBlankCopyBGNumRows] rows from hVBlankCopyBGSource to hVBlankCopyBGDest.
; If hVBlankCopyBGSource is XX00, the transfer is disabled.
VBlankCopyBgMap:
	ldh a, [lobyte(hVBlankCopyBGSource)] ; doubles as enabling byte
	and a
	ret z
	ld hl, sp+0
	ld a, h
	ldh [lobyte(hSPTemp)], a
	ld a, l
	ldh [lobyte(hSPTemp + 1)], a ; save stack pointer
	ldh a, [lobyte(hVBlankCopyBGSource)]
	ld l, a
	ldh a, [lobyte(hVBlankCopyBGSource + 1)]
	ld h, a
	ld sp, hl
	ldh a, [lobyte(hVBlankCopyBGDest)]
	ld l, a
	ldh a, [lobyte(hVBlankCopyBGDest + 1)]
	ld h, a
	ldh a, [lobyte(hVBlankCopyBGNumRows)]
	ld b, a
	xor a
	ldh [lobyte(hVBlankCopyBGSource)], a ; disable transfer so it doesn't continue next V-blank
	jr TransferBgRows


VBlankCopyDouble:
; Copy [hVBlankCopyDoubleSize] 1bpp tiles
; from hVBlankCopyDoubleSource to hVBlankCopyDoubleDest.

; While we're here, convert to 2bpp.
; The process is straightforward:
; copy each byte twice.

	ldh a, [lobyte(hVBlankCopyDoubleSize)]
	and a
	ret z

	ld hl, sp+0
	ld a, h
	ldh [lobyte(hSPTemp)], a
	ld a, l
	ldh [lobyte(hSPTemp + 1)], a

	ldh a, [lobyte(hVBlankCopyDoubleSource)]
	ld l, a
	ldh a, [lobyte(hVBlankCopyDoubleSource + 1)]
	ld h, a
	ld sp, hl

	ldh a, [lobyte(hVBlankCopyDoubleDest)]
	ld l, a
	ldh a, [lobyte(hVBlankCopyDoubleDest + 1)]
	ld h, a

	ldh a, [lobyte(hVBlankCopyDoubleSize)]
	ld b, a
	xor a ; transferred
	ldh [lobyte(hVBlankCopyDoubleSize)], a

VBlankCopyDouble.loop
.REPT TILE_SIZE / 4 - 1
	pop de
	ld [hl], e
	inc l
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	ld [hl], d
	inc l
.ENDR
	pop de
	ld [hl], e
	inc l
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	ld [hl], d
	inc hl
	dec b
	jr nz, VBlankCopyDouble.loop

	ld a, l
	ldh [lobyte(hVBlankCopyDoubleDest)], a
	ld a, h
	ldh [lobyte(hVBlankCopyDoubleDest + 1)], a

	ld hl, sp+0
	ld a, l
	ldh [lobyte(hVBlankCopyDoubleSource)], a
	ld a, h
	ldh [lobyte(hVBlankCopyDoubleSource + 1)], a

	ldh a, [lobyte(hSPTemp)]
	ld h, a
	ldh a, [lobyte(hSPTemp + 1)]
	ld l, a
	ld sp, hl

	ret


VBlankCopy:
; Copy [hVBlankCopySize] 2bpp tiles (or 16 * [hVBlankCopySize] tile map entries)
; from hVBlankCopySource to hVBlankCopyDest.

; Source and destination addresses are updated,
; so transfer can continue in subsequent calls.

	ldh a, [lobyte(hVBlankCopySize)]
	and a
	ret z

	ld hl, sp+0
	ld a, h
	ldh [lobyte(hSPTemp)], a
	ld a, l
	ldh [lobyte(hSPTemp + 1)], a

	ldh a, [lobyte(hVBlankCopySource)]
	ld l, a
	ldh a, [lobyte(hVBlankCopySource + 1)]
	ld h, a
	ld sp, hl

	ldh a, [lobyte(hVBlankCopyDest)]
	ld l, a
	ldh a, [lobyte(hVBlankCopyDest + 1)]
	ld h, a

	ldh a, [lobyte(hVBlankCopySize)]
	ld b, a
	xor a ; transferred
	ldh [lobyte(hVBlankCopySize)], a

VBlankCopy.loop
.REPT TILE_SIZE / 2 - 1
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
.ENDR
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc hl
	dec b
	jr nz, VBlankCopy.loop

	ld a, l
	ldh [lobyte(hVBlankCopyDest)], a
	ld a, h
	ldh [lobyte(hVBlankCopyDest + 1)], a

	ld hl, sp+0
	ld a, l
	ldh [lobyte(hVBlankCopySource)], a
	ld a, h
	ldh [lobyte(hVBlankCopySource + 1)], a

	ldh a, [lobyte(hSPTemp)]
	ld h, a
	ldh a, [lobyte(hSPTemp + 1)]
	ld l, a
	ld sp, hl

	ret


UpdateMovingBgTiles:
; Animate water and flower
; tiles in the overworld.

	ldh a, [lobyte(hTileAnimations)]
	and a
	ret z

	ldh a, [lobyte(hMovingBGTilesCounter1)]
	inc a
	ldh [lobyte(hMovingBGTilesCounter1)], a
	cp 20
	ret c
	cp 21
	jr z, UpdateMovingBgTiles.flower

; water

	ld hl, vTileset + TILE_SIZE * $14
	ld c, TILE_SIZE

	ld a, [wMovingBGTilesCounter2]
	inc a
	and 7
	ld [wMovingBGTilesCounter2], a

	and 4
	jr nz, UpdateMovingBgTiles.left
UpdateMovingBgTiles.right
	ld a, [hl]
	rrca
	ld [hli], a
	dec c
	jr nz, UpdateMovingBgTiles.right
	jr UpdateMovingBgTiles.done
UpdateMovingBgTiles.left
	ld a, [hl]
	rlca
	ld [hli], a
	dec c
	jr nz, UpdateMovingBgTiles.left
UpdateMovingBgTiles.done
	ldh a, [lobyte(hTileAnimations)]
	rrca
	ret nc

	xor a
	ldh [lobyte(hMovingBGTilesCounter1)], a
	ret

UpdateMovingBgTiles.flower
	xor a
	ldh [lobyte(hMovingBGTilesCounter1)], a

	ld a, [wMovingBGTilesCounter2]
	and 3
	cp 2
	ld hl, FlowerTile1
	jr c, UpdateMovingBgTiles.copy
	ld hl, FlowerTile2
	jr z, UpdateMovingBgTiles.copy
	ld hl, FlowerTile3
UpdateMovingBgTiles.copy
	ld de, vTileset + TILE_SIZE * $03
	ld c, TILE_SIZE
UpdateMovingBgTiles.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, UpdateMovingBgTiles.loop
	ret

FlowerTile1: .INCBIN "gfx/tilesets/flower/flower1.2bpp"
FlowerTile2: .INCBIN "gfx/tilesets/flower/flower2.2bpp"
FlowerTile3: .INCBIN "gfx/tilesets/flower/flower3.2bpp"
