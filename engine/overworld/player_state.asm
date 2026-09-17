; only used for setting BIT_STANDING_ON_WARP of wMovementFlags upon entering a new map
IsPlayerStandingOnWarp:
	ld a, [wNumberOfWarps]
	and a
	ret z
	ld c, a
	ld hl, wWarpEntries
IsPlayerStandingOnWarp.loop
	ld a, [wYCoord]
	cp [hl]
	jr nz, IsPlayerStandingOnWarp.nextWarp1
	inc hl
	ld a, [wXCoord]
	cp [hl]
	jr nz, IsPlayerStandingOnWarp.nextWarp2
	inc hl
	ld a, [hli] ; target warp
	ld [wDestinationWarpID], a
	ld a, [hl] ; target map
	ldh [lobyte(hWarpDestinationMap)], a
	ld hl, wMovementFlags
	set BIT_STANDING_ON_WARP, [hl]
	ret
IsPlayerStandingOnWarp.nextWarp1
	inc hl
IsPlayerStandingOnWarp.nextWarp2
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, IsPlayerStandingOnWarp.loop
	ret

CheckForceBikeOrSurf:
	ld hl, wStatusFlags6
	bit BIT_ALWAYS_ON_BIKE, [hl]
	ret nz
	ld hl, ForcedBikeOrSurfMaps
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	ld a, [wCurMap]
	ld d, a
CheckForceBikeOrSurf.loop
	ld a, [hli]
	cp $ff
	ret z ; if we reach FF then it's not part of the list
	cp d ; compare to current map
	jr nz, CheckForceBikeOrSurf.incorrectMap
	ld a, [hli]
	cp b ; compare y-coord
	jr nz, CheckForceBikeOrSurf.incorrectY
	ld a, [hli]
	cp c ; compare x-coord
	jr nz, CheckForceBikeOrSurf.loop ; incorrect x-coord, check next item
	ld a, [wCurMap]
	cp SEAFOAM_ISLANDS_B3F
	ld a, SCRIPT_SEAFOAMISLANDSB3F_MOVE_OBJECT
	ld [wSeafoamIslandsB3FCurScript], a
	jr z, CheckForceBikeOrSurf.forceSurfing
	ld a, [wCurMap]
	cp SEAFOAM_ISLANDS_B4F
	ld a, SCRIPT_SEAFOAMISLANDSB4F_MOVE_OBJECT
	ld [wSeafoamIslandsB4FCurScript], a
	jr z, CheckForceBikeOrSurf.forceSurfing
	ld hl, wStatusFlags6
	set BIT_ALWAYS_ON_BIKE, [hl]
	ld a, $1
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	jp ForceBikeOrSurf
CheckForceBikeOrSurf.incorrectMap
	inc hl
CheckForceBikeOrSurf.incorrectY
	inc hl
	jr CheckForceBikeOrSurf.loop
CheckForceBikeOrSurf.forceSurfing
	ld a, $2
	ld [wWalkBikeSurfState], a
	ld [wWalkBikeSurfStateCopy], a
	jp ForceBikeOrSurf

.INCLUDE "data/maps/force_bike_surf.asm"

IsPlayerFacingEdgeOfMap:
	push hl
	push de
	push bc
	ld a, [wSpritePlayerStateData1FacingDirection]
	srl a
	ld c, a
	ld b, $0
	ld hl, IsPlayerFacingEdgeOfMap.functionPointerTable
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	ld de, IsPlayerFacingEdgeOfMap.return
	push de
	jp hl
IsPlayerFacingEdgeOfMap.return
	pop bc
	pop de
	pop hl
	ret

IsPlayerFacingEdgeOfMap.functionPointerTable
	.DW IsPlayerFacingEdgeOfMap.facingDown
	.DW IsPlayerFacingEdgeOfMap.facingUp
	.DW IsPlayerFacingEdgeOfMap.facingLeft
	.DW IsPlayerFacingEdgeOfMap.facingRight

IsPlayerFacingEdgeOfMap.facingDown
	ld a, [wCurMapHeight]
	add a
	dec a
	cp b
	jr z, IsPlayerFacingEdgeOfMap.setCarry
	jr IsPlayerFacingEdgeOfMap.resetCarry

IsPlayerFacingEdgeOfMap.facingUp
	ld a, b
	and a
	jr z, IsPlayerFacingEdgeOfMap.setCarry
	jr IsPlayerFacingEdgeOfMap.resetCarry

IsPlayerFacingEdgeOfMap.facingLeft
	ld a, c
	and a
	jr z, IsPlayerFacingEdgeOfMap.setCarry
	jr IsPlayerFacingEdgeOfMap.resetCarry

IsPlayerFacingEdgeOfMap.facingRight
	ld a, [wCurMapWidth]
	add a
	dec a
	cp c
	jr z, IsPlayerFacingEdgeOfMap.setCarry
	jr IsPlayerFacingEdgeOfMap.resetCarry
IsPlayerFacingEdgeOfMap.resetCarry
	and a
	ret
IsPlayerFacingEdgeOfMap.setCarry
	scf
	ret

IsWarpTileInFrontOfPlayer:
	push hl
	push de
	push bc
	call WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer
	ld a, [wCurMap]
	cp SS_ANNE_BOW
	jr z, IsSSAnneBowWarpTileInFrontOfPlayer
	ld a, [wSpritePlayerStateData1FacingDirection]
	srl a
	ld c, a
	ld b, 0
	ld hl, WarpTileListPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTileInFrontOfPlayer]
	ld de, $1
	call IsInArray
IsWarpTileInFrontOfPlayer.done
	pop bc
	pop de
	pop hl
	ret

.INCLUDE "data/tilesets/warp_carpet_tile_ids.asm"

IsSSAnneBowWarpTileInFrontOfPlayer:
	ld a, [wTileInFrontOfPlayer]
	cp $15
	jr nz, IsSSAnneBowWarpTileInFrontOfPlayer.notSSAnne5Warp
	scf
	jr IsWarpTileInFrontOfPlayer.done
IsSSAnneBowWarpTileInFrontOfPlayer.notSSAnne5Warp
	and a
	jr IsWarpTileInFrontOfPlayer.done

IsPlayerStandingOnDoorTileOrWarpTile:
	push hl
	push de
	push bc
	farcall IsPlayerStandingOnDoorTile
	jr c, IsPlayerStandingOnDoorTileOrWarpTile.done
	ld a, [wCurMapTileset]
	add a
	ld c, a
	ld b, $0
	ld hl, WarpTileIDPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $1
	lda_coord 8, 9
	call IsInArray
	jr nc, IsPlayerStandingOnDoorTileOrWarpTile.done
	ld hl, wMovementFlags
	res BIT_STANDING_ON_WARP, [hl]
IsPlayerStandingOnDoorTileOrWarpTile.done
	pop bc
	pop de
	pop hl
	ret

.INCLUDE "data/tilesets/warp_tile_ids.asm"

PrintSafariZoneSteps:
	ld a, [wCurMap]
	cp SAFARI_ZONE_EAST
	ret c
	cp CERULEAN_CAVE_2F
	ret nc
	hlcoord 0, 0
	ld b, 3
	ld c, 7
	call TextBoxBorder
	hlcoord 1, 1
	ld de, wSafariSteps
	lb "bc", 2, 3
	call PrintNumber
	hlcoord 4, 1
	ld de, SafariSteps
	call PlaceString
	hlcoord 1, 3
	ld de, SafariBallText
	call PlaceString
	ld a, [wNumSafariBalls]
	cp 10
	jr nc, PrintSafariZoneSteps.tenOrMore
	hlcoord 5, 3
	ld a, $7f
	ld [hl], a
PrintSafariZoneSteps.tenOrMore
	hlcoord 6, 3
	ld de, wNumSafariBalls
	lb "bc", 1, 2
	jp PrintNumber

SafariSteps:
		.STRINGMAP pokemon, "/500@"

SafariBallText:
		.STRINGMAP pokemon, "BALL×× @"

GetTileAndCoordsInFrontOfPlayer:
	call GetPredefRegisters

_GetTileAndCoordsInFrontOfPlayer:
WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer:
	ld a, [wYCoord]
	ld d, a
	ld a, [wXCoord]
	ld e, a
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	jr nz, WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer__notFacingDown
; facing down
	lda_coord 8, 11
	inc d
	jr WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer__storeTile
_GetTileAndCoordsInFrontOfPlayer.notFacingDown:
WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer__notFacingDown:
	cp SPRITE_FACING_UP
	jr nz, WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer__notFacingUp
; facing up
	lda_coord 8, 7
	dec d
	jr WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer__storeTile
_GetTileAndCoordsInFrontOfPlayer.notFacingUp:
WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer__notFacingUp:
	cp SPRITE_FACING_LEFT
	jr nz, WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer__notFacingLeft
; facing left
	lda_coord 6, 9
	dec e
	jr WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer__storeTile
_GetTileAndCoordsInFrontOfPlayer.notFacingLeft:
WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer__notFacingLeft:
	cp SPRITE_FACING_RIGHT
	jr nz, WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer__storeTile
; facing right
	lda_coord 10, 9
	inc e
_GetTileAndCoordsInFrontOfPlayer.storeTile:
WLA_GLOBAL_GetTileAndCoordsInFrontOfPlayer__storeTile:
	ld c, a
	ld [wTileInFrontOfPlayer], a
	ret

; hPlayerFacing
	const_def
	const BIT_FACING_DOWN  ; 0
	const BIT_FACING_UP    ; 1
	const BIT_FACING_LEFT  ; 2
	const BIT_FACING_RIGHT ; 3

GetTileTwoStepsInFrontOfPlayer:
	xor a
	ldh [lobyte(hPlayerFacing)], a
	ld hl, wYCoord
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	jr nz, GetTileTwoStepsInFrontOfPlayer.notFacingDown
; facing down
	ld hl, hPlayerFacing
	set BIT_FACING_DOWN, [hl]
	lda_coord 8, 13
	inc d
	jr GetTileTwoStepsInFrontOfPlayer.storeTile
GetTileTwoStepsInFrontOfPlayer.notFacingDown
	cp SPRITE_FACING_UP
	jr nz, GetTileTwoStepsInFrontOfPlayer.notFacingUp
; facing up
	ld hl, hPlayerFacing
	set BIT_FACING_UP, [hl]
	lda_coord 8, 5
	dec d
	jr GetTileTwoStepsInFrontOfPlayer.storeTile
GetTileTwoStepsInFrontOfPlayer.notFacingUp
	cp SPRITE_FACING_LEFT
	jr nz, GetTileTwoStepsInFrontOfPlayer.notFacingLeft
; facing left
	ld hl, hPlayerFacing
	set BIT_FACING_LEFT, [hl]
	lda_coord 4, 9
	dec e
	jr GetTileTwoStepsInFrontOfPlayer.storeTile
GetTileTwoStepsInFrontOfPlayer.notFacingLeft
	cp SPRITE_FACING_RIGHT
	jr nz, GetTileTwoStepsInFrontOfPlayer.storeTile
; facing right
	ld hl, hPlayerFacing
	set BIT_FACING_RIGHT, [hl]
	lda_coord 12, 9
	inc e
GetTileTwoStepsInFrontOfPlayer.storeTile
	ld c, a
	ld [wTileInFrontOfBoulderAndBoulderCollisionResult], a
	ld [wTileInFrontOfPlayer], a
	ret

CheckForCollisionWhenPushingBoulder:
	call GetTileTwoStepsInFrontOfPlayer
	ld hl, wTilesetCollisionPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
CheckForCollisionWhenPushingBoulder.loop
	ld a, [hli]
	cp $ff
	jr z, CheckForCollisionWhenPushingBoulder.done ; if the tile two steps ahead is not passable
	cp c
	jr nz, CheckForCollisionWhenPushingBoulder.loop
	ld hl, TilePairCollisionsLand
	call CheckForTilePairCollisions2
	ld a, $ff
	jr c, CheckForCollisionWhenPushingBoulder.done ; if there is an elevation difference between the current tile and the one two steps ahead
	ld a, [wTileInFrontOfBoulderAndBoulderCollisionResult]
	cp $15 ; stairs tile
	ld a, $ff
	jr z, CheckForCollisionWhenPushingBoulder.done ; if the tile two steps ahead is stairs
	call CheckForBoulderCollisionWithSprites
CheckForCollisionWhenPushingBoulder.done
	ld [wTileInFrontOfBoulderAndBoulderCollisionResult], a
	ret

; sets a to $ff if there is a collision and $00 if there is no collision
CheckForBoulderCollisionWithSprites:
	ld a, [wBoulderSpriteIndex]
	dec a
	swap a
	ld d, 0
	ld e, a
	ld hl, wSprite01StateData2MapY
	add hl, de
	ld a, [hli] ; map Y position
	ldh [lobyte(hPlayerYCoord)], a
	ld a, [hl] ; map X position
	ldh [lobyte(hPlayerXCoord)], a
	ld a, [wNumSprites]
	ld c, a
	ld de, $f
	ld hl, wSprite01StateData2MapY
	ldh a, [lobyte(hPlayerFacing)]
	and (1 << BIT_FACING_UP) | (1 << BIT_FACING_DOWN)
	jr z, CheckForBoulderCollisionWithSprites.pushingHorizontallyLoop
CheckForBoulderCollisionWithSprites.pushingVerticallyLoop
	inc hl
	ldh a, [lobyte(hPlayerXCoord)]
	cp [hl]
	jr nz, CheckForBoulderCollisionWithSprites.nextSprite1 ; if X coordinates don't match
	dec hl
	ld a, [hli]
	ld b, a
	ldh a, [lobyte(hPlayerFacing)]
	.ASSERT ((BIT_FACING_DOWN)-(0)) < 1 && ((BIT_FACING_DOWN)-(0)) > -1
	rrca
	jr c, CheckForBoulderCollisionWithSprites.pushingDown
; pushing up
	ldh a, [lobyte(hPlayerYCoord)]
	dec a
	jr CheckForBoulderCollisionWithSprites.compareYCoords
CheckForBoulderCollisionWithSprites.pushingDown
	ldh a, [lobyte(hPlayerYCoord)]
	inc a
CheckForBoulderCollisionWithSprites.compareYCoords
	cp b
	jr z, CheckForBoulderCollisionWithSprites.failure
CheckForBoulderCollisionWithSprites.nextSprite1
	dec c
	jr z, CheckForBoulderCollisionWithSprites.success
	add hl, de
	jr CheckForBoulderCollisionWithSprites.pushingVerticallyLoop
CheckForBoulderCollisionWithSprites.pushingHorizontallyLoop
	ld a, [hli]
	ld b, a
	ldh a, [lobyte(hPlayerYCoord)]
	cp b
	jr nz, CheckForBoulderCollisionWithSprites.nextSprite2
	ld b, [hl]
	ldh a, [lobyte(hPlayerFacing)]
	bit BIT_FACING_LEFT, a
	jr nz, CheckForBoulderCollisionWithSprites.pushingLeft
; pushing right
	ldh a, [lobyte(hPlayerXCoord)]
	inc a
	jr CheckForBoulderCollisionWithSprites.compareXCoords
CheckForBoulderCollisionWithSprites.pushingLeft
	ldh a, [lobyte(hPlayerXCoord)]
	dec a
CheckForBoulderCollisionWithSprites.compareXCoords
	cp b
	jr z, CheckForBoulderCollisionWithSprites.failure
CheckForBoulderCollisionWithSprites.nextSprite2
	dec c
	jr z, CheckForBoulderCollisionWithSprites.success
	add hl, de
	jr CheckForBoulderCollisionWithSprites.pushingHorizontallyLoop
CheckForBoulderCollisionWithSprites.failure
	ld a, $ff
	ret
CheckForBoulderCollisionWithSprites.success
	xor a
	ret
