HandleLedges:
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	ret nz
	ld a, [wCurMapTileset]
	and a ; OVERWORLD
	ret nz
	predef GetTileAndCoordsInFrontOfPlayer
	ld a, [wSpritePlayerStateData1FacingDirection]
	ld b, a
	lda_coord 8, 9
	ld c, a
	ld a, [wTileInFrontOfPlayer]
	ld d, a
	ld hl, LedgeTiles
HandleLedges.loop
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr nz, HandleLedges.nextLedgeTile1
	ld a, [hli]
	cp c
	jr nz, HandleLedges.nextLedgeTile2
	ld a, [hli]
	cp d
	jr nz, HandleLedges.nextLedgeTile3
	ld a, [hl]
	ld e, a
	jr HandleLedges.foundMatch
HandleLedges.nextLedgeTile1
	inc hl
HandleLedges.nextLedgeTile2
	inc hl
HandleLedges.nextLedgeTile3
	inc hl
	jr HandleLedges.loop
HandleLedges.foundMatch
	ldh a, [lobyte(hJoyHeld)]
	and e
	ret z
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	ld hl, wMovementFlags
	set BIT_LEDGE_OR_FISHING, [hl]
	call StartSimulatingJoypadStates
	ld a, e
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, $2
	ld [wSimulatedJoypadStatesIndex], a
	call LoadHoppingShadowOAM
	ld a, SFX_LEDGE
	call PlaySound
	ret

.INCLUDE "data/tilesets/ledge_tiles.asm"

LoadHoppingShadowOAM:
	ld hl, vChars1 + TILE_SIZE * $7f
	ld de, LedgeHoppingShadow
	lb "bc", bank(LedgeHoppingShadow), (LedgeHoppingShadowEnd - LedgeHoppingShadow) / TILE_1BPP_SIZE
	call CopyVideoDataDouble
	ld a, $9
	lb "bc", $54, $48 ; b, c = y, x coordinates of shadow
	ld de, LedgeHoppingShadowOAMBlock
	call WriteOAMBlock
	ret

LedgeHoppingShadow:
	.INCBIN "gfx/overworld/shadow.1bpp"
LedgeHoppingShadowEnd:

LedgeHoppingShadowOAMBlock:
; tile ID, attributes
	.DB $ff, OAM_PAL1
	.DB $ff, OAM_XFLIP
	.DB $ff, OAM_YFLIP
	.DB $ff, OAM_XFLIP | OAM_YFLIP
