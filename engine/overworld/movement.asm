UpdatePlayerSprite:
	ld a, [wSpritePlayerStateData2WalkAnimationCounter]
	and a
	jr z, UpdatePlayerSprite.checkIfTextBoxInFrontOfSprite
	cp $ff
	jr z, UpdatePlayerSprite.disableSprite
	dec a
	ld [wSpritePlayerStateData2WalkAnimationCounter], a
	jr UpdatePlayerSprite.disableSprite
; check if a text box is in front of the sprite by checking if the lower left
; background tile the sprite is standing on is greater than $5F, which is
; the maximum number for map tiles
UpdatePlayerSprite.checkIfTextBoxInFrontOfSprite
	lda_coord 8, 9
	ldh [lobyte(hTilePlayerStandingOn)], a
	cp MAP_TILESET_SIZE
	jr c, UpdatePlayerSprite.lowerLeftTileIsMapTile
UpdatePlayerSprite.disableSprite
	ld a, $ff
	ld [wSpritePlayerStateData1ImageIndex], a
	ret
UpdatePlayerSprite.lowerLeftTileIsMapTile
	call DetectCollisionBetweenSprites
	ld h, hibyte(wSpriteStateData1)
	ld a, [wWalkCounter]
	and a
	jr nz, UpdatePlayerSprite.moving
	ld a, [wPlayerMovingDirection]
; check if down
	bit PLAYER_DIR_BIT_DOWN, a
	jr z, UpdatePlayerSprite.checkIfUp
	xor a ; ld a, SPRITE_FACING_DOWN
	jr UpdatePlayerSprite.next
UpdatePlayerSprite.checkIfUp
	bit PLAYER_DIR_BIT_UP, a
	jr z, UpdatePlayerSprite.checkIfLeft
	ld a, SPRITE_FACING_UP
	jr UpdatePlayerSprite.next
UpdatePlayerSprite.checkIfLeft
	bit PLAYER_DIR_BIT_LEFT, a
	jr z, UpdatePlayerSprite.checkIfRight
	ld a, SPRITE_FACING_LEFT
	jr UpdatePlayerSprite.next
UpdatePlayerSprite.checkIfRight
	bit PLAYER_DIR_BIT_RIGHT, a
	jr z, UpdatePlayerSprite.notMoving
	ld a, SPRITE_FACING_RIGHT
	jr UpdatePlayerSprite.next
UpdatePlayerSprite.notMoving
; zero the animation counters
	xor a
	ld [wSpritePlayerStateData1IntraAnimFrameCounter], a
	ld [wSpritePlayerStateData1AnimFrameCounter], a
	jr UpdatePlayerSprite.calcImageIndex
UpdatePlayerSprite.next
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, [wFontLoaded]
	bit BIT_FONT_LOADED, a
	jr nz, UpdatePlayerSprite.notMoving
UpdatePlayerSprite.moving
	ld a, [wMovementFlags]
	bit BIT_SPINNING, a
	jr nz, UpdatePlayerSprite.skipSpriteAnim
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $7
	ld l, a
	ld a, [hl]
	inc a
	ld [hl], a
	cp 4
	jr nz, UpdatePlayerSprite.calcImageIndex
	xor a
	ld [hl], a
	inc hl
	ld a, [hl]
	inc a
	and $3
	ld [hl], a
UpdatePlayerSprite.calcImageIndex
	ld a, [wSpritePlayerStateData1AnimFrameCounter]
	ld b, a
	ld a, [wSpritePlayerStateData1FacingDirection]
	add b
	ld [wSpritePlayerStateData1ImageIndex], a
UpdatePlayerSprite.skipSpriteAnim
; If the player is standing on a grass tile, make the player's sprite have
; lower priority than the background so that it's partially obscured by the
; grass. Only the lower half of the sprite is permitted to have the priority
; bit set by later logic.
	ldh a, [lobyte(hTilePlayerStandingOn)]
	ld c, a
	ld a, [wGrassTile]
	cp c
	ld a, 0
	jr nz, UpdatePlayerSprite.next2
	ld a, OAM_PRIO
UpdatePlayerSprite.next2
	ld [wSpritePlayerStateData2GrassPriority], a
	ret

UnusedReadSpriteDataFunction:
	push bc
	push af
	ldh a, [lobyte(hCurrentSpriteOffset)]
	ld c, a
	pop af
	add c
	ld l, a
	pop bc
	ret

UpdateNPCSprite:
	ldh a, [lobyte(hCurrentSpriteOffset)]
	swap a
	dec a
	add a
	ld hl, wMapSpriteData
	add l
	ld l, a
	ld a, [hl]        ; read movement byte 2
	ld [wCurSpriteMovement2], a
	ld h, hibyte(wSpriteStateData1)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	ld l, a
	inc l
	ld a, [hl]        ; x#SPRITESTATEDATA1_MOVEMENTSTATUS
	and a
	jp z, InitializeSpriteStatus
	call CheckSpriteAvailability
	ret c             ; don't do anything if sprite is invisible
	ld h, hibyte(wSpriteStateData1)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	ld l, a
	inc l
	ld a, [hl]        ; x#SPRITESTATEDATA1_MOVEMENTSTATUS
	bit BIT_FACE_PLAYER, a
	jp nz, MakeNPCFacePlayer
	ld b, a
	ld a, [wFontLoaded]
	bit BIT_FONT_LOADED, a
	jp nz, NotYetMoving
	ld a, b
	cp $2
	jp z, UpdateSpriteMovementDelay  ; [x#SPRITESTATEDATA1_MOVEMENTSTATUS] = 2
	cp $3
	jp z, UpdateSpriteInWalkingAnimation  ; [x#SPRITESTATEDATA1_MOVEMENTSTATUS] = 3
	ld a, [wWalkCounter]
	and a
	ret nz           ; don't do anything yet if player is currently moving
	call InitializeSpriteScreenPosition
	ld h, hibyte(wSpriteStateData2)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $6
	ld l, a
	ld a, [hl]       ; x#SPRITESTATEDATA2_MOVEMENTBYTE1
	inc a
	jr z, UpdateNPCSprite.randomMovement  ; value STAY
	inc a
	jr z, UpdateNPCSprite.randomMovement  ; value WALK
; scripted movement
	dec a
	ld [hl], a       ; increment movement byte 1 (movement data index)
	dec a
	push hl
	ld hl, wNPCNumScriptedSteps
	dec [hl]         ; decrement wNPCNumScriptedSteps
	pop hl
	ld de, wNPCMovementDirections
	call LoadDEPlusA ; a = [wNPCMovementDirections + movement byte 1]
	cp NPC_CHANGE_FACING
	jp z, ChangeFacingDirection
	cp STAY
	jr nz, UpdateNPCSprite.next
; reached end of wNPCMovementDirections list
	ld [hl], a ; store $ff in movement byte 1, disabling scripted movement
	ld hl, wStatusFlags5
	res BIT_SCRIPTED_NPC_MOVEMENT, [hl]
	xor a
	ld [wSimulatedJoypadStatesIndex], a
	ld [wUnusedOverrideSimulatedJoypadStatesIndex], a
	ret
UpdateNPCSprite.next
	cp WALK
	jr nz, UpdateNPCSprite.determineDirection
; current NPC movement data is WALK ($fe). this seems buggy
	ld [hl], $1     ; set movement byte 1 to $1
	ld de, wNPCMovementDirections
	call LoadDEPlusA ; a = [wNPCMovementDirections + $fe] (?)
	jr UpdateNPCSprite.determineDirection
UpdateNPCSprite.randomMovement
	call GetTileSpriteStandsOn
	call Random
UpdateNPCSprite.determineDirection
	ld b, a
	ld a, [wCurSpriteMovement2]
	cp DOWN
	jr z, UpdateNPCSprite.moveDown
	cp UP
	jr z, UpdateNPCSprite.moveUp
	cp LEFT
	jr z, UpdateNPCSprite.moveLeft
	cp RIGHT
	jr z, UpdateNPCSprite.moveRight
	ld a, b
	cp NPC_MOVEMENT_UP ; NPC_MOVEMENT_DOWN <= a < NPC_MOVEMENT_UP: down (or left)
	jr nc, UpdateNPCSprite.notDown
	ld a, [wCurSpriteMovement2]
	cp LEFT_RIGHT
	jr z, UpdateNPCSprite.moveLeft
UpdateNPCSprite.moveDown
	ld de, 2*SCREEN_WIDTH
	add hl, de         ; move tile pointer two rows down
	lb "de", 1, 0
	lb "bc", 4, SPRITE_FACING_DOWN
	jr TryWalking
UpdateNPCSprite.notDown
	cp NPC_MOVEMENT_LEFT ; NPC_MOVEMENT_UP <= a < NPC_MOVEMENT_LEFT: up (or right)
	jr nc, UpdateNPCSprite.notUp
	ld a, [wCurSpriteMovement2]
	cp LEFT_RIGHT
	jr z, UpdateNPCSprite.moveRight
UpdateNPCSprite.moveUp
	ld de, -2*SCREEN_WIDTH
	add hl, de         ; move tile pointer two rows up
	lb "de", -1, 0
	lb "bc", 8, SPRITE_FACING_UP
	jr TryWalking
UpdateNPCSprite.notUp
	cp NPC_MOVEMENT_RIGHT ; NPC_MOVEMENT_LEFT <= a < NPC_MOVEMENT_RIGHT: left (or up)
	jr nc, UpdateNPCSprite.notLeft
	ld a, [wCurSpriteMovement2]
	cp UP_DOWN
	jr z, UpdateNPCSprite.moveUp
UpdateNPCSprite.moveLeft
	dec hl
	dec hl             ; move tile pointer two columns left
	lb "de", 0, -1
	lb "bc", 2, SPRITE_FACING_LEFT
	jr TryWalking
UpdateNPCSprite.notLeft               ; NPC_MOVEMENT_RIGHT <= a: right (or down)
	ld a, [wCurSpriteMovement2]
	cp UP_DOWN
	jr z, UpdateNPCSprite.moveDown
UpdateNPCSprite.moveRight
	inc hl
	inc hl             ; move tile pointer two columns right
	lb "de", 0, 1
	lb "bc", 1, SPRITE_FACING_RIGHT
	jr TryWalking

; changes facing direction by zeroing the movement delta and calling TryWalking
ChangeFacingDirection:
	ld de, $0
	; fall through

; b: direction (1,2,4 or 8)
; c: new facing direction (0,4,8 or $c)
; d: Y movement delta (-1, 0 or 1)
; e: X movement delta (-1, 0 or 1)
; hl: pointer to tile the sprite would walk onto
; set carry on failure, clears carry on success
TryWalking:
	push hl
	ld h, hibyte(wSpriteStateData1)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $9
	ld l, a
	ld [hl], c          ; x#SPRITESTATEDATA1_FACINGDIRECTION
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $3
	ld l, a
	ld [hl], d          ; x#SPRITESTATEDATA1_YSTEPVECTOR
	inc l
	inc l
	ld [hl], e          ; x#SPRITESTATEDATA1_XSTEPVECTOR
	pop hl
	push de
	ld c, [hl]          ; read tile to walk onto
	call CanWalkOntoTile
	pop de
	ret c               ; cannot walk there (reinitialization of delay values already done)
	ld h, hibyte(wSpriteStateData2)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $4
	ld l, a
	ld a, [hl]          ; x#SPRITESTATEDATA2_MAPY
	add d
	ld [hli], a         ; update Y position
	ld a, [hl]          ; x#SPRITESTATEDATA2_MAPX
	add e
	ld [hl], a          ; update X position
	ldh a, [lobyte(hCurrentSpriteOffset)]
	ld l, a
	ld [hl], $10        ; [x#SPRITESTATEDATA2_WALKANIMATIONCOUNTER] = 16
	dec h
	inc l
	ld [hl], $3         ; x#SPRITESTATEDATA1_MOVEMENTSTATUS
	jp UpdateSpriteImage

; update the walking animation parameters for a sprite that is currently walking
UpdateSpriteInWalkingAnimation:
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $7
	ld l, a
	ld a, [hl]                       ; x#SPRITESTATEDATA1_INTRAANIMFRAMECOUNTER
	inc a
	ld [hl], a                       ; [x#SPRITESTATEDATA1_INTRAANIMFRAMECOUNTER]++
	cp $4
	jr nz, UpdateSpriteInWalkingAnimation.noNextAnimationFrame
	xor a
	ld [hl], a                       ; [x#SPRITESTATEDATA1_INTRAANIMFRAMECOUNTER] = 0
	inc l
	ld a, [hl]                       ; x#SPRITESTATEDATA1_ANIMFRAMECOUNTER
	inc a
	and $3
	ld [hl], a                       ; advance to next animation frame every 4 ticks (16 ticks total for one step)
UpdateSpriteInWalkingAnimation.noNextAnimationFrame
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $3
	ld l, a
	ld a, [hli]                      ; x#SPRITESTATEDATA1_YSTEPVECTOR
	ld b, a
	ld a, [hl]                       ; x#SPRITESTATEDATA1_YPIXELS
	add b
	ld [hli], a                      ; update [x#SPRITESTATEDATA1_YPIXELS]
	ld a, [hli]                      ; x#SPRITESTATEDATA1_XSTEPVECTOR
	ld b, a
	ld a, [hl]                       ; x#SPRITESTATEDATA1_XPIXELS
	add b
	ld [hl], a                       ; update [x#SPRITESTATEDATA1_XPIXELS]
	ldh a, [lobyte(hCurrentSpriteOffset)]
	ld l, a
	inc h
	ld a, [hl]                       ; x#SPRITESTATEDATA2_WALKANIMATIONCOUNTER
	dec a
	ld [hl], a                       ; update walk animation counter
	ret nz
	ld a, $6                         ; walking finished, update state
	add l
	ld l, a
	ld a, [hl]                       ; x#SPRITESTATEDATA2_MOVEMENTBYTE1
	cp WALK
	jr nc, UpdateSpriteInWalkingAnimation.initNextMovementCounter  ; values WALK or STAY
	ldh a, [lobyte(hCurrentSpriteOffset)]
	inc a
	ld l, a
	dec h
	ld [hl], $1                      ; [x#SPRITESTATEDATA1_MOVEMENTSTATUS] = 1 (movement status ready)
	ret
UpdateSpriteInWalkingAnimation.initNextMovementCounter
	call Random
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $8
	ld l, a
	ldh a, [lobyte(hRandomAdd)]
	and $7f
	ld [hl], a                       ; x#SPRITESTATEDATA2_MOVEMENTDELAY:
	                                 ; set next movement delay to a random value in [0,$7f]
	                                 ; note that value 0 actually makes the delay $100 (bug?)
	dec h ; hibyte(wSpriteStateData1)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	inc a
	ld l, a
	ld [hl], $2                      ; [x#SPRITESTATEDATA1_MOVEMENTSTATUS] = 2 (movement status)
	inc l
	inc l
	xor a
	ld b, [hl]                       ; x#SPRITESTATEDATA1_YSTEPVECTOR
	ld [hli], a                      ; [x#SPRITESTATEDATA1_YSTEPVECTOR] = 0
	inc l
	ld c, [hl]                       ; x#SPRITESTATEDATA1_XSTEPVECTOR
	ld [hl], a                       ; [x#SPRITESTATEDATA1_XSTEPVECTOR] = 0
	ret

; update [x#SPRITESTATEDATA2_MOVEMENTDELAY] for sprites in the delayed state (x#SPRITESTATEDATA1_MOVEMENTSTATUS)
UpdateSpriteMovementDelay:
	ld h, hibyte(wSpriteStateData2)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $6
	ld l, a
	ld a, [hl]              ; x#SPRITESTATEDATA2_MOVEMENTBYTE1
	inc l
	inc l
	cp WALK
	jr nc, UpdateSpriteMovementDelay.tickMoveCounter ; values WALK or STAY
	ld [hl], $0
	jr UpdateSpriteMovementDelay.moving
UpdateSpriteMovementDelay.tickMoveCounter
	dec [hl]                ; x#SPRITESTATEDATA2_MOVEMENTDELAY
	jr nz, NotYetMoving
UpdateSpriteMovementDelay.moving
	dec h
	ldh a, [lobyte(hCurrentSpriteOffset)]
	inc a
	ld l, a
	ld [hl], $1             ; [x#SPRITESTATEDATA1_MOVEMENTSTATUS] = 1 (mark as ready to move)
	; fallthrough
NotYetMoving:
	ld h, hibyte(wSpriteStateData1)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add SPRITESTATEDATA1_ANIMFRAMECOUNTER
	ld l, a
	ld [hl], $0             ; [x#SPRITESTATEDATA1_ANIMFRAMECOUNTER] = 0 (walk animation frame)
	jp UpdateSpriteImage

MakeNPCFacePlayer:
; Make an NPC face the player if the player has spoken to him or her.

; Check if the behaviour of the NPC facing the player when spoken to is
; disabled. This is only done when rubbing the S.S. Anne captain's back.
	ld a, [wStatusFlags3]
	bit BIT_NO_NPC_FACE_PLAYER, a
	jr nz, NotYetMoving
	res BIT_FACE_PLAYER, [hl]
	ld a, [wPlayerDirection]
	bit PLAYER_DIR_BIT_UP, a
	jr z, MakeNPCFacePlayer.notFacingDown
	ld c, SPRITE_FACING_DOWN
	jr MakeNPCFacePlayer.facingDirectionDetermined
MakeNPCFacePlayer.notFacingDown
	bit PLAYER_DIR_BIT_DOWN, a
	jr z, MakeNPCFacePlayer.notFacingUp
	ld c, SPRITE_FACING_UP
	jr MakeNPCFacePlayer.facingDirectionDetermined
MakeNPCFacePlayer.notFacingUp
	bit PLAYER_DIR_BIT_LEFT, a
	jr z, MakeNPCFacePlayer.notFacingRight
	ld c, SPRITE_FACING_RIGHT
	jr MakeNPCFacePlayer.facingDirectionDetermined
MakeNPCFacePlayer.notFacingRight
	ld c, SPRITE_FACING_LEFT
MakeNPCFacePlayer.facingDirectionDetermined
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $9
	ld l, a
	ld [hl], c              ; [x#SPRITESTATEDATA1_FACINGDIRECTION]: set facing direction
	jr NotYetMoving

InitializeSpriteStatus:
	ld [hl], $1   ; [x#SPRITESTATEDATA1_MOVEMENTSTATUS] = ready
	inc l
	ld [hl], $ff  ; [x#SPRITESTATEDATA1_IMAGEINDEX] = invisible/off screen
	inc h ; hibyte(wSpriteStateData2)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $2
	ld l, a
	ld a, $8
	ld [hli], a   ; [x#SPRITESTATEDATA2_YDISPLACEMENT] = 8
	ld [hl], a    ; [x#SPRITESTATEDATA2_XDISPLACEMENT] = 8
	ret

; calculates the sprite's screen position from its map position and the player position
InitializeSpriteScreenPosition:
	ld h, hibyte(wSpriteStateData2)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add SPRITESTATEDATA2_MAPY
	ld l, a
	ld a, [wYCoord]
	ld b, a
	ld a, [hl]      ; x#SPRITESTATEDATA2_MAPY
	sub b           ; relative to player position
	swap a          ; * 16
	sub $4          ; - 4
	dec h
	ld [hli], a     ; [x#SPRITESTATEDATA1_YPIXELS]
	inc h
	ld a, [wXCoord]
	ld b, a
	ld a, [hli]     ; x#SPRITESTATEDATA2_MAPX
	sub b           ; relative to player position
	swap a          ; * 16
	dec h
	ld [hl], a      ; [x#SPRITESTATEDATA1_XPIXELS]
	ret

; tests if sprite is off screen or otherwise unable to do anything
CheckSpriteAvailability:
	predef IsObjectHidden
	ldh a, [lobyte(hIsToggleableObjectOff)]
	and a
	jp nz, CheckSpriteAvailability.spriteInvisible
	ld h, hibyte(wSpriteStateData2)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add SPRITESTATEDATA2_MOVEMENTBYTE1
	ld l, a
	ld a, [hl]      ; x#SPRITESTATEDATA2_MOVEMENTBYTE1
	cp WALK
	jr c, CheckSpriteAvailability.skipXVisibilityTest ; movement byte 1 < WALK (i.e. the sprite's movement is scripted)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add SPRITESTATEDATA2_MAPY
	ld l, a
	ld b, [hl]      ; x#SPRITESTATEDATA2_MAPY
	ld a, [wYCoord]
	cp b
	jr z, CheckSpriteAvailability.skipYVisibilityTest
	jr nc, CheckSpriteAvailability.spriteInvisible ; above screen region
	add SCREEN_HEIGHT / 2 - 1
	cp b
	jr c, CheckSpriteAvailability.spriteInvisible  ; below screen region
CheckSpriteAvailability.skipYVisibilityTest
	inc l
	ld b, [hl]      ; x#SPRITESTATEDATA2_MAPX
	ld a, [wXCoord]
	cp b
	jr z, CheckSpriteAvailability.skipXVisibilityTest
	jr nc, CheckSpriteAvailability.spriteInvisible ; left of screen region
	add SCREEN_WIDTH / 2 - 1
	cp b
	jr c, CheckSpriteAvailability.spriteInvisible  ; right of screen region
CheckSpriteAvailability.skipXVisibilityTest
; make the sprite invisible if a text box is in front of it
; $5F is the maximum number for map tiles
	call GetTileSpriteStandsOn
	ld d, MAP_TILESET_SIZE
	ld a, [hli]
	cp d
	jr nc, CheckSpriteAvailability.spriteInvisible ; standing on tile with ID >=MAP_TILESET_SIZE (bottom left tile)
	ld a, [hld]
	cp d
	jr nc, CheckSpriteAvailability.spriteInvisible ; standing on tile with ID >=MAP_TILESET_SIZE (bottom right tile)
	ld bc, -SCREEN_WIDTH
	add hl, bc              ; go back one row of tiles
	ld a, [hli]
	cp d
	jr nc, CheckSpriteAvailability.spriteInvisible ; standing on tile with ID >=MAP_TILESET_SIZE (top left tile)
	ld a, [hl]
	cp d
	jr c, CheckSpriteAvailability.spriteVisible    ; standing on tile with ID >=MAP_TILESET_SIZE (top right tile)
CheckSpriteAvailability.spriteInvisible
	ld h, hibyte(wSpriteStateData1)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add SPRITESTATEDATA1_IMAGEINDEX
	ld l, a
	ld [hl], $ff       ; x#SPRITESTATEDATA1_IMAGEINDEX
	scf
	jr CheckSpriteAvailability.done
CheckSpriteAvailability.spriteVisible
	ld c, a
	ld a, [wWalkCounter]
	and a
	jr nz, CheckSpriteAvailability.done           ; if player is currently walking, we're done
	call UpdateSpriteImage
	inc h
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $7
	ld l, a
	ld a, [wGrassTile]
	cp c
	ld a, 0
	jr nz, CheckSpriteAvailability.notInGrass
	ld a, OAM_PRIO
CheckSpriteAvailability.notInGrass
	ld [hl], a       ; x#SPRITESTATEDATA2_GRASSPRIORITY
	and a
CheckSpriteAvailability.done
	ret

UpdateSpriteImage:
	ld h, hibyte(wSpriteStateData1)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $8
	ld l, a
	ld a, [hli]        ; x#SPRITESTATEDATA1_ANIMFRAMECOUNTER
	ld b, a
	ld a, [hl]         ; x#SPRITESTATEDATA1_FACINGDIRECTION
	add b
	ld b, a
	ldh a, [lobyte(hTilePlayerStandingOn)]
	add b
	ld b, a
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $2
	ld l, a
	ld [hl], b         ; x#SPRITESTATEDATA1_IMAGEINDEX
	ret

; tests if sprite can walk the specified direction
; b: direction (1,2,4 or 8)
; c: ID of tile the sprite would walk onto
; d: Y movement delta (-1, 0 or 1)
; e: X movement delta (-1, 0 or 1)
; set carry on failure, clears carry on success
CanWalkOntoTile:
	ld h, hibyte(wSpriteStateData2)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add SPRITESTATEDATA2_MOVEMENTBYTE1
	ld l, a
	ld a, [hl]         ; x#SPRITESTATEDATA2_MOVEMENTBYTE1
	cp WALK
	jr nc, CanWalkOntoTile.notScripted    ; values WALK or STAY
; always allow walking if the movement is scripted
	and a
	ret
CanWalkOntoTile.notScripted
	ld a, [wTilesetCollisionPtr]
	ld l, a
	ld a, [wTilesetCollisionPtr+1]
	ld h, a
CanWalkOntoTile.tilePassableLoop
	ld a, [hli]
	cp $ff
	jr z, CanWalkOntoTile.impassable
	cp c
	jr nz, CanWalkOntoTile.tilePassableLoop
	ld h, hibyte(wSpriteStateData2)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $6
	ld l, a
	ld a, [hl]         ; x#SPRITESTATEDATA2_MOVEMENTBYTE1
	inc a
	jr z, CanWalkOntoTile.impassable  ; if $ff, no movement allowed (however, changing direction is)
	ld h, hibyte(wSpriteStateData1)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add SPRITESTATEDATA1_YPIXELS
	ld l, a
	ld a, [hli]        ; x#SPRITESTATEDATA1_YPIXELS
	add $4             ; align to blocks (Y pos is always 4 pixels off)
	add d              ; add Y delta
	cp $80             ; if value is >$80, the destination is off screen (either $81 or $FF underflow)
	jr nc, CanWalkOntoTile.impassable ; don't walk off screen
	inc l
	ld a, [hl]         ; x#SPRITESTATEDATA1_XPIXELS
	add e              ; add X delta
	cp $90             ; if value is >$90, the destination is off screen (either $91 or $FF underflow)
	jr nc, CanWalkOntoTile.impassable ; don't walk off screen
	push de
	push bc
	call DetectCollisionBetweenSprites
	pop bc
	pop de
	ld h, hibyte(wSpriteStateData1)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $c
	ld l, a
	ld a, [hl]         ; x#SPRITESTATEDATA1_COLLISIONDATA (directions in which sprite collision would occur)
	and b              ; check against chosen direction (1,2,4 or 8)
	jr nz, CanWalkOntoTile.impassable ; collision between sprites, don't go there
	ld h, hibyte(wSpriteStateData2)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add SPRITESTATEDATA2_YDISPLACEMENT
	ld l, a
	ld a, [hli]        ; x#SPRITESTATEDATA2_YDISPLACEMENT (initialized at $8, keep track of where a sprite did go)
	bit 7, d           ; check if going upwards (d = -1)
	jr nz, CanWalkOntoTile.upwards
	add d
	; bug: these tests against $5 probably were supposed to prevent
	; sprites from walking out too far, but this line makes sprites get
	; stuck whenever they walked upwards 5 steps
	; on the other hand, the amount a sprite can walk out to the
	; right of bottom is not limited (until the counter overflows)
	cp $5
	jr c, CanWalkOntoTile.impassable  ; if [x#SPRITESTATEDATA2_YDISPLACEMENT]+d < 5, don't go
	jr CanWalkOntoTile.checkHorizontal
CanWalkOntoTile.upwards
	sub $1
	jr c, CanWalkOntoTile.impassable  ; if [x#SPRITESTATEDATA2_YDISPLACEMENT] = 0, don't go
CanWalkOntoTile.checkHorizontal
	ld d, a
	ld a, [hl]         ; x#SPRITESTATEDATA2_XDISPLACEMENT (initialized at $8, keep track of where a sprite did go)
	bit 7, e           ; check if going left (e = -1)
	jr nz, CanWalkOntoTile.left
	add e
	cp $5              ; compare, but no conditional jump like in the vertical check above (bug?)
	jr CanWalkOntoTile.passable
CanWalkOntoTile.left
	sub $1
	jr c, CanWalkOntoTile.impassable  ; if [x#SPRITESTATEDATA2_XDISPLACEMENT] = 0, don't go
CanWalkOntoTile.passable
	ld [hld], a        ; update x#SPRITESTATEDATA2_XDISPLACEMENT
	ld [hl], d         ; update x#SPRITESTATEDATA2_YDISPLACEMENT
	and a              ; clear carry (marking success)
	ret
CanWalkOntoTile.impassable
	ld h, hibyte(wSpriteStateData1)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	inc a
	ld l, a
	ld [hl], $2        ; [x#SPRITESTATEDATA1_MOVEMENTSTATUS] = 2 (delayed)
	inc l
	inc l
	xor a
	ld [hli], a        ; [x#SPRITESTATEDATA1_YSTEPVECTOR] = 0
	inc l
	ld [hl], a         ; [x#SPRITESTATEDATA1_XSTEPVECTOR] = 0
	inc h
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $8
	ld l, a
	call Random
	ldh a, [lobyte(hRandomAdd)]
	and $7f
	ld [hl], a         ; x#SPRITESTATEDATA2_MOVEMENTDELAY: set to a random value in [0,$7f] (again with delay $100 if value is 0)
	scf                ; set carry (marking failure to walk)
	ret

; calculates the tile pointer pointing to the tile the current sprite stands on
; this is always the lower left tile of the 2x2 tile blocks all sprites are snapped to
; hl: output pointer
GetTileSpriteStandsOn:
	ld h, hibyte(wSpriteStateData1)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add SPRITESTATEDATA1_YPIXELS
	ld l, a
	ld a, [hli]     ; x#SPRITESTATEDATA1_YPIXELS
	add $4          ; align to 2*2 tile blocks (Y position is always off 4 pixels to the top)
	and $f0         ; in case object is currently moving
	srl a           ; screen Y tile * 4
	ld c, a
	ld b, $0
	inc l
	ld a, [hl]      ; x#SPRITESTATEDATA1_XPIXELS
	srl a
	srl a
	srl a            ; screen X tile
	add SCREEN_WIDTH ; screen X tile + 20
	ld d, $0
	ld e, a
	hlcoord 0, 0
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, bc
	add hl, de     ; wTileMap + 20*(screen Y tile + 1) + screen X tile
	ret

; loads [de+a] into a
LoadDEPlusA:
	add e
	ld e, a
	jr nc, LoadDEPlusA.noCarry
	inc d
LoadDEPlusA.noCarry
	ld a, [de]
	ret

DoScriptedNPCMovement:
; This is an alternative method of scripting an NPC's movement and is only used
; a few times in the game. It is used when the NPC and player must walk together
; in sync, such as when the player is following the NPC somewhere. An NPC can't
; be moved in sync with the player using the other method.
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_MOVEMENT_STATE, a
	ret z
	ld hl, wStatusFlags4
	bit BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	set BIT_INIT_SCRIPTED_MOVEMENT, [hl]
	jp z, InitScriptedNPCMovement
	ld hl, wNPCMovementDirections2
	ld a, [wNPCMovementDirections2Index]
	add l
	ld l, a
	jr nc, DoScriptedNPCMovement.noCarry
	inc h
DoScriptedNPCMovement.noCarry
	ld a, [hl]
; check if moving up
	cp NPC_MOVEMENT_UP
	jr nz, DoScriptedNPCMovement.checkIfMovingDown
	call GetSpriteScreenYPointer
	ld c, SPRITE_FACING_UP
	ld a, -2
	jr DoScriptedNPCMovement.move
DoScriptedNPCMovement.checkIfMovingDown
	cp NPC_MOVEMENT_DOWN
	jr nz, DoScriptedNPCMovement.checkIfMovingLeft
	call GetSpriteScreenYPointer
	ld c, SPRITE_FACING_DOWN
	ld a, 2
	jr DoScriptedNPCMovement.move
DoScriptedNPCMovement.checkIfMovingLeft
	cp NPC_MOVEMENT_LEFT
	jr nz, DoScriptedNPCMovement.checkIfMovingRight
	call GetSpriteScreenXPointer
	ld c, SPRITE_FACING_LEFT
	ld a, -2
	jr DoScriptedNPCMovement.move
DoScriptedNPCMovement.checkIfMovingRight
	cp NPC_MOVEMENT_RIGHT
	jr nz, DoScriptedNPCMovement.noMatch
	call GetSpriteScreenXPointer
	ld c, SPRITE_FACING_RIGHT
	ld a, 2
	jr DoScriptedNPCMovement.move
DoScriptedNPCMovement.noMatch
	cp $ff
	ret
DoScriptedNPCMovement.move
	ld b, a
	ld a, [hl]
	add b
	ld [hl], a
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $9
	ld l, a
	ld a, c
	ld [hl], a ; facing direction
	call AnimScriptedNPCMovement
	ld hl, wScriptedNPCWalkCounter
	dec [hl]
	ret nz
	ld a, 8
	ld [wScriptedNPCWalkCounter], a
	ld hl, wNPCMovementDirections2Index
	inc [hl]
	ret

InitScriptedNPCMovement:
	xor a
	ld [wNPCMovementDirections2Index], a
	ld a, 8
	ld [wScriptedNPCWalkCounter], a
	jp AnimScriptedNPCMovement

GetSpriteScreenYPointer:
	ld a, SPRITESTATEDATA1_YPIXELS
	ld b, a
	jr GetSpriteScreenXYPointerCommon

GetSpriteScreenXPointer:
	ld a, SPRITESTATEDATA1_XPIXELS
	ld b, a

GetSpriteScreenXYPointerCommon:
	ld hl, wSpriteStateData1
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add l
	add b
	ld l, a
	ret

AnimScriptedNPCMovement:
	ld hl, wSpriteStateData2
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add SPRITESTATEDATA2_IMAGEBASEOFFSET
	ld l, a
	ld a, [hl] ; VRAM slot
	dec a
	swap a
	ld b, a
	ld hl, wSpriteStateData1
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add SPRITESTATEDATA1_FACINGDIRECTION
	ld l, a
	ld a, [hl] ; facing direction
	cp SPRITE_FACING_DOWN
	jr z, AnimScriptedNPCMovement.anim
	cp SPRITE_FACING_UP
	jr z, AnimScriptedNPCMovement.anim
	cp SPRITE_FACING_LEFT
	jr z, AnimScriptedNPCMovement.anim
	cp SPRITE_FACING_RIGHT
	jr z, AnimScriptedNPCMovement.anim
	ret
AnimScriptedNPCMovement.anim
	add b
	ld b, a
	ldh [lobyte(hSpriteVRAMSlotAndFacing)], a
	call AdvanceScriptedNPCAnimFrameCounter
	ld hl, wSpriteStateData1
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add SPRITESTATEDATA1_IMAGEINDEX
	ld l, a
	ldh a, [lobyte(hSpriteVRAMSlotAndFacing)]
	ld b, a
	ldh a, [lobyte(hSpriteAnimFrameCounter)]
	add b
	ld [hl], a
	ret

AdvanceScriptedNPCAnimFrameCounter:
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add $7
	ld l, a
	ld a, [hl] ; intra-animation frame counter
	inc a
	ld [hl], a
	cp 4
	ret nz
	xor a
	ld [hl], a ; reset intra-animation frame counter
	inc l
	ld a, [hl] ; animation frame counter
	inc a
	and $3
	ld [hl], a
	ldh [lobyte(hSpriteAnimFrameCounter)], a
	ret
