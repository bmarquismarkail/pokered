FarCopyData2:
; Identical to FarCopyData, but uses hROMBankTemp
; as temp space instead of wBuffer.
	ldh [lobyte(hROMBankTemp)], a
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ldh a, [lobyte(hROMBankTemp)]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	call CopyData
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret

FarCopyData3:
; Copy bc bytes from a:de to hl.
	ldh [lobyte(hROMBankTemp)], a
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ldh a, [lobyte(hROMBankTemp)]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	push hl
	push de
	push de
	ld d, h
	ld e, l
	pop hl
	call CopyData
	pop de
	pop hl
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret

FarCopyDataDouble:
; Expand bc bytes of 1bpp image data
; from a:hl to 2bpp data at de.
	ldh [lobyte(hROMBankTemp)], a
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ldh a, [lobyte(hROMBankTemp)]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
FarCopyDataDouble.loop
	ld a, [hli]
	ld [de], a
	inc de
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, FarCopyDataDouble.loop
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret

CopyVideoData:
; Wait for the next VBlank, then copy c 2bpp
; tiles from b:de to hl, 8 * TILE_SIZE at a time.
; This takes c/8 frames.

	ldh a, [lobyte(hAutoBGTransferEnabled)]
	push af
	xor a ; disable auto-transfer while copying
	ldh [lobyte(hAutoBGTransferEnabled)], a

	ldh a, [lobyte(hLoadedROMBank)]
	ldh [lobyte(hROMBankTemp)], a

	ld a, b
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a

	ld a, e
	ldh [lobyte(hVBlankCopySource)], a
	ld a, d
	ldh [lobyte(hVBlankCopySource + 1)], a

	ld a, l
	ldh [lobyte(hVBlankCopyDest)], a
	ld a, h
	ldh [lobyte(hVBlankCopyDest + 1)], a

CopyVideoData.loop
	ld a, c
	cp 8
	jr nc, CopyVideoData.keepgoing

CopyVideoData.done
	ldh [lobyte(hVBlankCopySize)], a
	call DelayFrame
	ldh a, [lobyte(hROMBankTemp)]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	pop af
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ret

CopyVideoData.keepgoing
	ld a, 8
	ldh [lobyte(hVBlankCopySize)], a
	call DelayFrame
	ld a, c
	sub 8
	ld c, a
	jr CopyVideoData.loop

CopyVideoDataDouble:
; Wait for the next VBlank, then copy c 1bpp
; tiles from b:de to hl, 8 * TILE_SIZE at a time.
; This takes c/8 frames.
	ldh a, [lobyte(hAutoBGTransferEnabled)]
	push af
	xor a ; disable auto-transfer while copying
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ldh a, [lobyte(hLoadedROMBank)]
	ldh [lobyte(hROMBankTemp)], a

	ld a, b
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a

	ld a, e
	ldh [lobyte(hVBlankCopyDoubleSource)], a
	ld a, d
	ldh [lobyte(hVBlankCopyDoubleSource + 1)], a

	ld a, l
	ldh [lobyte(hVBlankCopyDoubleDest)], a
	ld a, h
	ldh [lobyte(hVBlankCopyDoubleDest + 1)], a

CopyVideoDataDouble.loop
	ld a, c
	cp 8
	jr nc, CopyVideoDataDouble.keepgoing

CopyVideoDataDouble.done
	ldh [lobyte(hVBlankCopyDoubleSize)], a
	call DelayFrame
	ldh a, [lobyte(hROMBankTemp)]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	pop af
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ret

CopyVideoDataDouble.keepgoing
	ld a, 8
	ldh [lobyte(hVBlankCopyDoubleSize)], a
	call DelayFrame
	ld a, c
	sub 8
	ld c, a
	jr CopyVideoDataDouble.loop

ClearScreenArea:
; Clear tilemap area cxb at hl.
	ld a, $7f
	ld de, SCREEN_WIDTH
ClearScreenArea.loopRows
	push hl
	push bc
ClearScreenArea.loopTiles
	ld [hli], a
	dec c
	jr nz, ClearScreenArea.loopTiles
	pop bc
	pop hl
	add hl, de
	dec b
	jr nz, ClearScreenArea.loopRows
	ret

CopyScreenTileBufferToVRAM:
; Copy wTileMap to the BG Map starting at b * $100.
; This is done in thirds of 6 rows, so it takes 3 frames.

	ld c, SCREEN_HEIGHT / 3

	lb "hl", 0, 0
	decoord 0, 6 * 0
	call CopyScreenTileBufferToVRAM.setup
	call DelayFrame

	lb "hl", SCREEN_HEIGHT / 3, 0
	decoord 0, 6 * 1
	call CopyScreenTileBufferToVRAM.setup
	call DelayFrame

	lb "hl", 2 * SCREEN_HEIGHT / 3, 0
	decoord 0, 6 * 2
	call CopyScreenTileBufferToVRAM.setup
	jp DelayFrame

CopyScreenTileBufferToVRAM.setup
	ld a, d
	ldh [lobyte(hVBlankCopyBGSource+1)], a
	call GetRowColAddressBgMap
	ld a, l
	ldh [lobyte(hVBlankCopyBGDest)], a
	ld a, h
	ldh [lobyte(hVBlankCopyBGDest+1)], a
	ld a, c
	ldh [lobyte(hVBlankCopyBGNumRows)], a
	ld a, e
	ldh [lobyte(hVBlankCopyBGSource)], a
	ret

ClearScreen:
; Clear wTileMap, then wait
; for the bg map to update.
	ld bc, SCREEN_AREA
	inc b
	hlcoord 0, 0
	ld a, $7f
ClearScreen.loop
	ld [hli], a
	dec c
	jr nz, ClearScreen.loop
	dec b
	jr nz, ClearScreen.loop
	jp Delay3
