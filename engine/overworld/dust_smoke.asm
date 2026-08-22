AnimateBoulderDust:
	ld a, $1
	ld [wWhichAnimationOffsets], a ; select the boulder dust offsets
	ld a, [wUpdateSpritesEnabled]
	push af
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	ld a, %11100100
	ldh [lobyte(rOBP1)], a
	call LoadSmokeTileFourTimes
	farcall WriteCutOrBoulderDustAnimationOAMBlock
	ld c, 8 ; number of steps in animation
AnimateBoulderDust.loop
	push bc
	call GetMoveBoulderDustFunctionPointer
	ld bc, AnimateBoulderDust.returnAddress
	push bc
	ld c, 4
	jp hl
AnimateBoulderDust.returnAddress
	ldh a, [lobyte(rOBP1)]
	xor %01100100
	ldh [lobyte(rOBP1)], a
	call Delay3
	pop bc
	dec c
	jr nz, AnimateBoulderDust.loop
	pop af
	ld [wUpdateSpritesEnabled], a
	jp LoadPlayerSpriteGraphics

GetMoveBoulderDustFunctionPointer:
	ld a, [wSpritePlayerStateData1FacingDirection]
	ld hl, MoveBoulderDustFunctionPointerTable
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hli]
	ld [wCoordAdjustmentAmount], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld hl, wShadowOAMSprite36
	ld d, $0
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ret

.MACRO boulder_dust_adjust
	.DB \1, \2 ; coords
	.DW \3 ; function
.ENDM

MoveBoulderDustFunctionPointerTable:
	boulder_dust_adjust -1, 0, AdjustOAMBlockYPos ; down
	boulder_dust_adjust  1, 0, AdjustOAMBlockYPos ; up
	boulder_dust_adjust  1, 1, AdjustOAMBlockXPos ; left
	boulder_dust_adjust -1, 1, AdjustOAMBlockXPos ; right

LoadSmokeTileFourTimes:
	ld hl, vChars1 + TILE_SIZE * $7c
	ld c, 4
LoadSmokeTileFourTimes.loop
	push bc
	push hl
	call LoadSmokeTile
	pop hl
	ld bc, TILE_SIZE
	add hl, bc
	pop bc
	dec c
	jr nz, LoadSmokeTileFourTimes.loop
	ret

LoadSmokeTile:
	ld de, SSAnneSmokePuffTile
	lb "bc", bank(SSAnneSmokePuffTile), (SSAnneSmokePuffTileEnd - SSAnneSmokePuffTile) / TILE_SIZE
	jp CopyVideoData

SSAnneSmokePuffTile:
	.INCBIN "gfx/overworld/smoke.2bpp"
SSAnneSmokePuffTileEnd:
