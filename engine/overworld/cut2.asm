AnimCut:
	ld a, [wCutTile]
	cp $52
	jr z, AnimCut.grass
	ld c, $8
AnimCut.cutTreeLoop
	push bc
	ld hl, wShadowOAMSprite36XCoord
	ld a, 1
	ld [wCoordAdjustmentAmount], a
	ld c, 2
	call AdjustOAMBlockXPos2
	ld hl, wShadowOAMSprite38XCoord
	ld a, -1
	ld [wCoordAdjustmentAmount], a
	ld c, 2
	call AdjustOAMBlockXPos2
	ldh a, [lobyte(rOBP1)]
	xor $64
	ldh [lobyte(rOBP1)], a
	call DelayFrame
	pop bc
	dec c
	jr nz, AnimCut.cutTreeLoop
	ret
AnimCut.grass
	ld c, 2
AnimCut.cutGrassLoop
	push bc
	ld c, $8
	call AnimCutGrass_UpdateOAMEntries
	call AnimCutGrass_SwapOAMEntries
	ld c, $8
	call AnimCutGrass_UpdateOAMEntries
	call AnimCutGrass_SwapOAMEntries
	ld hl, wShadowOAMSprite36YCoord
	ld a, 2
	ld [wCoordAdjustmentAmount], a
	ld c, 4
	call AdjustOAMBlockYPos2
	pop bc
	dec c
	jr nz, AnimCut.cutGrassLoop
	ret

AnimCutGrass_UpdateOAMEntries:
	push bc
	ld hl, wShadowOAMSprite36XCoord
	ld a, 1
	ld [wCoordAdjustmentAmount], a
	ld c, 1
	call AdjustOAMBlockXPos2
	ld hl, wShadowOAMSprite37XCoord
	ld a, 2
	ld [wCoordAdjustmentAmount], a
	ld c, 1
	call AdjustOAMBlockXPos2
	ld hl, wShadowOAMSprite38XCoord
	ld a, -2
	ld [wCoordAdjustmentAmount], a
	ld c, 1
	call AdjustOAMBlockXPos2
	ld hl, wShadowOAMSprite39XCoord
	ld a, -1
	ld [wCoordAdjustmentAmount], a
	ld c, 1
	call AdjustOAMBlockXPos2
	ldh a, [lobyte(rOBP1)]
	xor $64
	ldh [lobyte(rOBP1)], a
	call DelayFrame
	pop bc
	dec c
	jr nz, AnimCutGrass_UpdateOAMEntries
	ret

AnimCutGrass_SwapOAMEntries:
	ld hl, wShadowOAMSprite36
	ld de, wBuffer
	ld bc, 2 * OBJ_SIZE
	call CopyData
	ld hl, wShadowOAMSprite38
	ld de, wShadowOAMSprite36
	ld bc, 2 * OBJ_SIZE
	call CopyData
	ld hl, wBuffer
	ld de, wShadowOAMSprite38
	ld bc, 2 * OBJ_SIZE
	jp CopyData
