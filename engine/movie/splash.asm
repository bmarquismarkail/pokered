LoadShootingStarGraphics:
	ld a, $f9
	ldh [lobyte(rOBP0)], a
	ld a, $a4
	ldh [lobyte(rOBP1)], a
	ld de, MoveAnimationTiles1 + TILE_SIZE * 3 ; star + TILE_SIZE * (top left quadrant)
	ld hl, vChars1 + TILE_SIZE * $20
	lb "bc", bank(MoveAnimationTiles1), 1
	call CopyVideoData
	ld de, MoveAnimationTiles1 + TILE_SIZE * 19 ; star + TILE_SIZE * (bottom left quadrant)
	ld hl, vChars1 + TILE_SIZE * $21
	lb "bc", bank(MoveAnimationTiles1), 1
	call CopyVideoData
	ld de, FallingStar
	ld hl, vChars1 + TILE_SIZE * $22
	lb "bc", bank(FallingStar), (FallingStarEnd - FallingStar) / TILE_SIZE
	call CopyVideoData
	ld hl, GameFreakLogoOAMData
	ld de, wShadowOAMSprite24
	ld bc, GameFreakLogoOAMDataEnd - GameFreakLogoOAMData
	call CopyData
	ld hl, GameFreakShootingStarOAMData
	ld de, wShadowOAM
	ld bc, GameFreakShootingStarOAMDataEnd - GameFreakShootingStarOAMData
	jp CopyData

AnimateShootingStar:
	call LoadShootingStarGraphics
	ld a, SFX_SHOOTING_STAR
	call PlaySound

; Move the big star down and left across the screen.
	ld hl, wShadowOAM
	lb "bc", $a0, $4
AnimateShootingStar.bigStarLoop
	push hl
	push bc
AnimateShootingStar.bigStarInnerLoop
	ld a, [hl] ; Y
	add 4
	ld [hli], a
	ld a, [hl] ; X
	add -4
	ld [hli], a
	inc hl
	inc hl
	dec c
	jr nz, AnimateShootingStar.bigStarInnerLoop
	ld c, 1
	call CheckForUserInterruption
	pop bc
	pop hl
	ret c
	ld a, [hl]
	cp 80
	jr nz, AnimateShootingStar.next
	jr AnimateShootingStar.bigStarLoop
AnimateShootingStar.next
	cp b
	jr nz, AnimateShootingStar.bigStarLoop

; Clear big star OAM.
	ld hl, wShadowOAMSprite00YCoord
	ld c, 4
	ld de, OBJ_SIZE
AnimateShootingStar.clearOAMLoop
	ld [hl], SCREEN_HEIGHT_PX + OAM_Y_OFS
	add hl, de
	dec c
	jr nz, AnimateShootingStar.clearOAMLoop

; Make Gamefreak logo flash.
	ld b, 3
AnimateShootingStar.flashLogoLoop
	ld hl, rOBP0
	rrc [hl]
	rrc [hl]
	ld c, 10
	call CheckForUserInterruption
	ret c
	dec b
	jr nz, AnimateShootingStar.flashLogoLoop

; Copy 24 instances of the small stars OAM data.
; Note that their coordinates put them off-screen.
	ld de, wShadowOAM
	ld a, 24
AnimateShootingStar.initSmallStarsOAMLoop
	push af
	ld hl, SmallStarsOAM
	ld bc, SmallStarsOAMEnd - SmallStarsOAM
	call CopyData
	pop af
	dec a
	jr nz, AnimateShootingStar.initSmallStarsOAMLoop

; Animate the small stars falling from the Gamefreak logo.
	xor a
	ld [wMoveDownSmallStarsOAMCount], a
	ld hl, SmallStarsWaveCoordsPointerTable
	ld c, 6
AnimateShootingStar.smallStarsLoop
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push bc
	push hl
	ld hl, wShadowOAMSprite20
	ld c, 4
AnimateShootingStar.smallStarsInnerLoop ; introduce new wave of 4 small stars OAM entries
	ld a, [de]
	cp -1
	jr z, AnimateShootingStar.next2
	ld [hli], a ; Y
	inc de
	ld a, [de]
	ld [hli], a ; X
	inc de
	inc hl
	inc hl
	dec c
	jr nz, AnimateShootingStar.smallStarsInnerLoop
	ld a, [wMoveDownSmallStarsOAMCount]
	cp 24
	jr z, AnimateShootingStar.next2
	add 6 ; should be 4, but the extra 2 aren't visible on screen
	ld [wMoveDownSmallStarsOAMCount], a
AnimateShootingStar.next2
	call MoveDownSmallStars
	push af

; shift the existing OAM entries down to make room for the next wave
	ld hl, wShadowOAMSprite04
	ld de, wShadowOAM
	ld bc, OBJ_SIZE * 20
	call CopyData

	pop af
	pop hl
	pop bc
	ret c
	dec c
	jr nz, AnimateShootingStar.smallStarsLoop
	and a
	ret

SmallStarsOAM:
	dbsprite  0,  0,  0,  0, $A2, OAM_PRIO | OAM_PAL1
SmallStarsOAMEnd:

SmallStarsWaveCoordsPointerTable:
	.DW SmallStarsWave1Coords
	.DW SmallStarsWave2Coords
	.DW SmallStarsWave3Coords
	.DW SmallStarsWave4Coords
	.DW SmallStarsEmptyWave
	.DW SmallStarsEmptyWave

; The stars that fall from the Gamefreak logo come in 4 waves of 4 OAM entries.
; These arrays contain the Y and X coordinates of each OAM entry.

SmallStarsWave1Coords:
	.DB $68, $30
	.DB $68, $40
	.DB $68, $58
	.DB $68, $78
SmallStarsWave2Coords:
	.DB $68, $38
	.DB $68, $48
	.DB $68, $60
	.DB $68, $70
SmallStarsWave3Coords:
	.DB $68, $34
	.DB $68, $4C
	.DB $68, $54
	.DB $68, $64
SmallStarsWave4Coords:
	.DB $68, $3C
	.DB $68, $5C
	.DB $68, $6C
	.DB $68, $74
SmallStarsEmptyWave:
	.DB -1 ; end

MoveDownSmallStars:
	ld b, 8
MoveDownSmallStars.loop
	ld hl, wShadowOAMSprite23
	ld a, [wMoveDownSmallStarsOAMCount]
	ld de, -4
	ld c, a
MoveDownSmallStars.innerLoop
	inc [hl] ; Y
	add hl, de
	dec c
	jr nz, MoveDownSmallStars.innerLoop
; Toggle the palette so that the lower star in the small stars + TILE_SIZE * blinks in
; and out.
	ldh a, [lobyte(rOBP1)]
	xor %10100000
	ldh [lobyte(rOBP1)], a

	ld c, 3
	call CheckForUserInterruption
	ret c
	dec b
	jr nz, MoveDownSmallStars.loop
	ret

GameFreakLogoOAMData:
	dbsprite 10,  9,  0,  0, $8d, 0
	dbsprite 11,  9,  0,  0, $8e, 0
	dbsprite 10, 10,  0,  0, $8f, 0
	dbsprite 11, 10,  0,  0, $90, 0
	dbsprite 10, 11,  0,  0, $91, 0
	dbsprite 11, 11,  0,  0, $92, 0
	dbsprite  6, 12,  0,  0, $80, 0
	dbsprite  7, 12,  0,  0, $81, 0
	dbsprite  8, 12,  0,  0, $82, 0
	dbsprite  9, 12,  0,  0, $83, 0
	dbsprite 10, 12,  0,  0, $93, 0
	dbsprite 11, 12,  0,  0, $84, 0
	dbsprite 12, 12,  0,  0, $85, 0
	dbsprite 13, 12,  0,  0, $83, 0
	dbsprite 14, 12,  0,  0, $81, 0
	dbsprite 15, 12,  0,  0, $86, 0
GameFreakLogoOAMDataEnd:

GameFreakShootingStarOAMData:
	dbsprite 20,  0,  0,  0, $a0, OAM_PAL1
	dbsprite 21,  0,  0,  0, $a0, OAM_PAL1 | OAM_XFLIP
	dbsprite 20,  1,  0,  0, $a1, OAM_PAL1
	dbsprite 21,  1,  0,  0, $a1, OAM_PAL1 | OAM_XFLIP
GameFreakShootingStarOAMDataEnd:

FallingStar:
	.INCBIN "gfx/splash/falling_star.2bpp"
FallingStarEnd:
