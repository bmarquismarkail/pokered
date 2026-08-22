_GetSpritePosition1:
WLA_GLOBAL_GetSpritePosition1:
	ld hl, wSpriteStateData1
	ld de, SPRITESTATEDATA1_YPIXELS
	ld a, [wSpriteIndex]
	ldh [lobyte(hSpriteIndex)], a
	call GetSpriteDataPointer
	ld a, [hli] ; x#SPRITESTATEDATA1_YPIXELS
	ldh [lobyte(hSpriteScreenYCoord)], a
	inc hl
	ld a, [hl] ; x#SPRITESTATEDATA1_XPIXELS
	ldh [lobyte(hSpriteScreenXCoord)], a
	ld de, wSpritePlayerStateData2MapY - wSpritePlayerStateData1XPixels
	add hl, de
	ld a, [hli] ; x#SPRITESTATEDATA2_MAPY
	ldh [lobyte(hSpriteMapYCoord)], a
	ld a, [hl] ; x#SPRITESTATEDATA2_MAPX
	ldh [lobyte(hSpriteMapXCoord)], a
	ret

_GetSpritePosition2:
WLA_GLOBAL_GetSpritePosition2:
	ld hl, wSpriteStateData1
	ld de, SPRITESTATEDATA1_YPIXELS
	ld a, [wSpriteIndex]
	ldh [lobyte(hSpriteIndex)], a
	call GetSpriteDataPointer
	ld a, [hli] ; x#SPRITESTATEDATA1_YPIXELS
	ld [wSavedSpriteScreenY], a
	inc hl
	ld a, [hl] ; x#SPRITESTATEDATA1_XPIXELS
	ld [wSavedSpriteScreenX], a
	ld de, wSpritePlayerStateData2MapY - wSpritePlayerStateData1XPixels
	add hl, de
	ld a, [hli] ; x#SPRITESTATEDATA2_MAPY
	ld [wSavedSpriteMapY], a
	ld a, [hl] ; x#SPRITESTATEDATA2_MAPX
	ld [wSavedSpriteMapX], a
	ret

_SetSpritePosition1:
WLA_GLOBAL_SetSpritePosition1:
	ld hl, wSpriteStateData1
	ld de, SPRITESTATEDATA1_YPIXELS
	ld a, [wSpriteIndex]
	ldh [lobyte(hSpriteIndex)], a
	call GetSpriteDataPointer
	ldh a, [lobyte(hSpriteScreenYCoord)] ; x#SPRITESTATEDATA1_YPIXELS
	ld [hli], a
	inc hl
	ldh a, [lobyte(hSpriteScreenXCoord)] ; x#SPRITESTATEDATA1_XPIXELS
	ld [hl], a
	ld de, wSpritePlayerStateData2MapY - wSpritePlayerStateData1XPixels
	add hl, de
	ldh a, [lobyte(hSpriteMapYCoord)] ; x#SPRITESTATEDATA2_MAPY
	ld [hli], a
	ldh a, [lobyte(hSpriteMapXCoord)] ; x#SPRITESTATEDATA2_MAPX
	ld [hl], a
	ret

_SetSpritePosition2:
WLA_GLOBAL_SetSpritePosition2:
	ld hl, wSpriteStateData1
	ld de, SPRITESTATEDATA1_YPIXELS
	ld a, [wSpriteIndex]
	ldh [lobyte(hSpriteIndex)], a
	call GetSpriteDataPointer
	ld a, [wSavedSpriteScreenY]
	ld [hli], a ; x#SPRITESTATEDATA1_YPIXELS
	inc hl
	ld a, [wSavedSpriteScreenX]
	ld [hl], a ; x#SPRITESTATEDATA1_XPIXELS
	ld de, wSpritePlayerStateData2MapY - wSpritePlayerStateData1XPixels
	add hl, de
	ld a, [wSavedSpriteMapY]
	ld [hli], a ; x#SPRITESTATEDATA2_MAPY
	ld a, [wSavedSpriteMapX]
	ld [hl], a ; x#SPRITESTATEDATA2_MAPX
	ret

TrainerWalkUpToPlayer:
	ld a, [wSpriteIndex]
	swap a
	ld [wTrainerSpriteOffset], a
	call ReadTrainerScreenPosition
	ld a, [wTrainerFacingDirection]
	and a ; SPRITE_FACING_DOWN
	jr z, TrainerWalkUpToPlayer.facingDown
	cp SPRITE_FACING_UP
	jr z, TrainerWalkUpToPlayer.facingUp
	cp SPRITE_FACING_LEFT
	jr z, TrainerWalkUpToPlayer.facingLeft
	jr TrainerWalkUpToPlayer.facingRight
TrainerWalkUpToPlayer.facingDown
	ld a, [wTrainerScreenY]
	ld b, a
	ld a, $3c           ; (fixed) player screen Y pos
	call CalcDifference
	cp $10              ; trainer is right above player
	ret z
	swap a
	dec a
	ld c, a             ; bc = steps yet to go to reach player
	xor a ; NPC_MOVEMENT_DOWN
	ld b, a
	jr TrainerWalkUpToPlayer.writeWalkScript
TrainerWalkUpToPlayer.facingUp
	ld a, [wTrainerScreenY]
	ld b, a
	ld a, $3c           ; (fixed) player screen Y pos
	call CalcDifference
	cp $10              ; trainer is right below player
	ret z
	swap a
	dec a
	ld c, a             ; bc = steps yet to go to reach player
	ld b, $0
	ld a, NPC_MOVEMENT_UP
	jr TrainerWalkUpToPlayer.writeWalkScript
TrainerWalkUpToPlayer.facingRight
	ld a, [wTrainerScreenX]
	ld b, a
	ld a, $40           ; (fixed) player screen X pos
	call CalcDifference
	cp $10              ; trainer is directly left of player
	ret z
	swap a
	dec a
	ld c, a             ; bc = steps yet to go to reach player
	ld b, $0
	ld a, NPC_MOVEMENT_RIGHT
	jr TrainerWalkUpToPlayer.writeWalkScript
TrainerWalkUpToPlayer.facingLeft
	ld a, [wTrainerScreenX]
	ld b, a
	ld a, $40           ; (fixed) player screen X pos
	call CalcDifference
	cp $10              ; trainer is directly right of player
	ret z
	swap a
	dec a
	ld c, a             ; bc = steps yet to go to reach player
	ld b, $0
	ld a, NPC_MOVEMENT_LEFT
TrainerWalkUpToPlayer.writeWalkScript
	ld hl, wNPCMovementDirections2
	ld de, wNPCMovementDirections2
	call FillMemory     ; write the necessary steps to reach player
	ld [hl], $ff        ; write end of list sentinel
	ld a, [wSpriteIndex]
	ldh [lobyte(hSpriteIndex)], a
	jp MoveSprite_

; input: de = offset within sprite entry
; output: hl = pointer to sprite data
GetSpriteDataPointer:
	push de
	add hl, de
	ldh a, [lobyte(hSpriteIndex)]
	swap a
	ld d, $0
	ld e, a
	add hl, de
	pop de
	ret

; tests if this trainer is in the right position to engage the player and do so if she is.
TrainerEngage:
	push hl
	push de
	ld a, [wTrainerSpriteOffset]
	add SPRITESTATEDATA1_IMAGEINDEX
	ld d, $0
	ld e, a
	ld hl, wSpriteStateData1
	add hl, de
	ld a, [hl]             ; x#SPRITESTATEDATA1_IMAGEINDEX
	sub $ff
	jr nz, TrainerEngage.spriteOnScreen ; test if sprite is on screen
	jp TrainerEngage.noEngage
TrainerEngage.spriteOnScreen
	ld a, [wTrainerSpriteOffset]
	add SPRITESTATEDATA1_FACINGDIRECTION
	ld d, $0
	ld e, a
	ld hl, wSpriteStateData1
	add hl, de
	ld a, [hl]             ; x#SPRITESTATEDATA1_FACINGDIRECTION
	ld [wTrainerFacingDirection], a
	call ReadTrainerScreenPosition
	ld a, [wTrainerScreenY]          ; sprite screen Y pos
	ld b, a
	ld a, $3c
	cp b
	jr z, TrainerEngage.linedUpY
	ld a, [wTrainerScreenX]          ; sprite screen X pos
	ld b, a
	ld a, $40
	cp b
	jr z, TrainerEngage.linedUpX
	xor a
	jp TrainerEngage.noEngage
TrainerEngage.linedUpY
	ld a, [wTrainerScreenX]        ; sprite screen X pos
	ld b, a
	ld a, $40            ; (fixed) player X position
	call CalcDifference  ; calc distance
	jr z, TrainerEngage.noEngage      ; exact same position as player
	call CheckSpriteCanSeePlayer
	jr c, TrainerEngage.engage
	xor a
	jr TrainerEngage.noEngage
TrainerEngage.linedUpX
	ld a, [wTrainerScreenY]        ; sprite screen Y pos
	ld b, a
	ld a, $3c            ; (fixed) player Y position
	call CalcDifference  ; calc distance
	jr z, TrainerEngage.noEngage      ; exact same position as player
	call CheckSpriteCanSeePlayer
	jr c, TrainerEngage.engage
	xor a
	jp TrainerEngage.noEngage
TrainerEngage.engage
	call CheckPlayerIsInFrontOfSprite
	ld a, [wTrainerSpriteOffset]
	and a
	jr z, TrainerEngage.noEngage
	ld hl, wMiscFlags
	set BIT_SEEN_BY_TRAINER, [hl]
	call EngageMapTrainer
	ld a, $ff
TrainerEngage.noEngage
	ld [wTrainerSpriteOffset], a
	pop de
	pop hl
	ret

; reads trainer's Y position to wTrainerScreenY and X position to wTrainerScreenX
ReadTrainerScreenPosition:
	ld a, [wTrainerSpriteOffset]
	add SPRITESTATEDATA1_YPIXELS
	ld d, $0
	ld e, a
	ld hl, wSpriteStateData1
	add hl, de
	ld a, [hl] ; x#SPRITESTATEDATA1_YPIXELS
	ld [wTrainerScreenY], a
	ld a, [wTrainerSpriteOffset]
	add SPRITESTATEDATA1_XPIXELS
	ld d, $0
	ld e, a
	ld hl, wSpriteStateData1
	add hl, de
	ld a, [hl] ; x#SPRITESTATEDATA1_XPIXELS
	ld [wTrainerScreenX], a
	ret

; checks if the sprite is properly lined up with the player with respect to the direction it's looking. Also checks the distance between player and sprite
; note that this does not necessarily mean the sprite is seeing the player, he could be behind it's back
; a: distance player to sprite
CheckSpriteCanSeePlayer:
	ld b, a
	ld a, [wTrainerEngageDistance] ; how far the trainer can see
	cp b
	jr nc, CheckSpriteCanSeePlayer.checkIfLinedUp
	jr CheckSpriteCanSeePlayer.notInLine         ; player too far away
CheckSpriteCanSeePlayer.checkIfLinedUp
	ld a, [wTrainerFacingDirection]         ; sprite facing direction
	cp SPRITE_FACING_DOWN
	jr z, CheckSpriteCanSeePlayer.checkXCoord
	cp SPRITE_FACING_UP
	jr z, CheckSpriteCanSeePlayer.checkXCoord
	cp SPRITE_FACING_LEFT
	jr z, CheckSpriteCanSeePlayer.checkYCoord
	cp SPRITE_FACING_RIGHT
	jr z, CheckSpriteCanSeePlayer.checkYCoord
	jr CheckSpriteCanSeePlayer.notInLine
CheckSpriteCanSeePlayer.checkXCoord
	ld a, [wTrainerScreenX]         ; sprite screen X position
	ld b, a
	cp $40
	jr z, CheckSpriteCanSeePlayer.inLine
	jr CheckSpriteCanSeePlayer.notInLine
CheckSpriteCanSeePlayer.checkYCoord
	ld a, [wTrainerScreenY]         ; sprite screen Y position
	ld b, a
	cp $3c
	jr nz, CheckSpriteCanSeePlayer.notInLine
CheckSpriteCanSeePlayer.inLine
	scf
	ret
CheckSpriteCanSeePlayer.notInLine
	and a
	ret

; tests if the player is in front of the sprite (rather than behind it)
CheckPlayerIsInFrontOfSprite:
	ld a, [wCurMap]
	cp POWER_PLANT
	jp z, CheckPlayerIsInFrontOfSprite.engage       ; bypass this for power plant to get voltorb fake items to work
	ld a, [wTrainerSpriteOffset]
	add SPRITESTATEDATA1_YPIXELS
	ld d, $0
	ld e, a
	ld hl, wSpriteStateData1
	add hl, de
	ld a, [hl]          ; x#SPRITESTATEDATA1_YPIXELS
	cp $fc
	jr nz, CheckPlayerIsInFrontOfSprite.notOnTopmostTile ; special case if sprite is on topmost tile (Y = $fc (-4)), make it come down a block
	ld a, $c
CheckPlayerIsInFrontOfSprite.notOnTopmostTile
	ld [wTrainerScreenY], a
	ld a, [wTrainerSpriteOffset]
	add SPRITESTATEDATA1_XPIXELS
	ld d, $0
	ld e, a
	ld hl, wSpriteStateData1
	add hl, de
	ld a, [hl]          ; x#SPRITESTATEDATA1_XPIXELS
	ld [wTrainerScreenX], a
	ld a, [wTrainerFacingDirection]       ; facing direction
	cp SPRITE_FACING_DOWN
	jr nz, CheckPlayerIsInFrontOfSprite.notFacingDown
	ld a, [wTrainerScreenY]       ; sprite screen Y pos
	cp $3c
	jr c, CheckPlayerIsInFrontOfSprite.engage       ; sprite above player
	jr CheckPlayerIsInFrontOfSprite.noEngage        ; sprite below player
CheckPlayerIsInFrontOfSprite.notFacingDown
	cp SPRITE_FACING_UP
	jr nz, CheckPlayerIsInFrontOfSprite.notFacingUp
	ld a, [wTrainerScreenY]       ; sprite screen Y pos
	cp $3c
	jr nc, CheckPlayerIsInFrontOfSprite.engage      ; sprite below player
	jr CheckPlayerIsInFrontOfSprite.noEngage        ; sprite above player
CheckPlayerIsInFrontOfSprite.notFacingUp
	cp SPRITE_FACING_LEFT
	jr nz, CheckPlayerIsInFrontOfSprite.notFacingLeft
	ld a, [wTrainerScreenX]       ; sprite screen X pos
	cp $40
	jr nc, CheckPlayerIsInFrontOfSprite.engage      ; sprite right of player
	jr CheckPlayerIsInFrontOfSprite.noEngage        ; sprite left of player
CheckPlayerIsInFrontOfSprite.notFacingLeft
	ld a, [wTrainerScreenX]       ; sprite screen X pos
	cp $40
	jr nc, CheckPlayerIsInFrontOfSprite.noEngage    ; sprite right of player
CheckPlayerIsInFrontOfSprite.engage
	ld a, $ff
	jr CheckPlayerIsInFrontOfSprite.done
CheckPlayerIsInFrontOfSprite.noEngage
	xor a
CheckPlayerIsInFrontOfSprite.done
	ld [wTrainerSpriteOffset], a
	ret
