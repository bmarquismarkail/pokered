_UpdateSprites:
WLA_GLOBAL_UpdateSprites:
	ld h, hibyte(wSpriteStateData1)
	inc h
	ld a, SPRITESTATEDATA2_IMAGEBASEOFFSET
_UpdateSprites.spriteLoop:
WLA_GLOBAL_UpdateSprites__spriteLoop:
	ld l, a
	sub SPRITESTATEDATA2_IMAGEBASEOFFSET
	ld c, a
	ldh [lobyte(hCurrentSpriteOffset)], a
	ld a, [hl]
	and a
	jr z, WLA_GLOBAL_UpdateSprites__skipSprite   ; tests SPRITESTATEDATA2_IMAGEBASEOFFSET
	push hl
	push de
	push bc
	call WLA_GLOBAL_UpdateSprites__updateCurrentSprite
	pop bc
	pop de
	pop hl
_UpdateSprites.skipSprite:
WLA_GLOBAL_UpdateSprites__skipSprite:
	ld a, l
	add $10             ; move to next sprite
	cp SPRITESTATEDATA2_IMAGEBASEOFFSET ; test for overflow (back at beginning)
	jr nz, WLA_GLOBAL_UpdateSprites__spriteLoop
	ret
_UpdateSprites.updateCurrentSprite:
WLA_GLOBAL_UpdateSprites__updateCurrentSprite:
	cp $1
	jp nz, UpdateNonPlayerSprite
	jp UpdatePlayerSprite

UpdateNonPlayerSprite:
	dec a
	swap a
	ldh [lobyte(hTilePlayerStandingOn)], a  ; $10 * sprite#
	ld a, [wNPCMovementScriptSpriteOffset] ; some sprite offset?
	ld b, a
	ldh a, [lobyte(hCurrentSpriteOffset)]
	cp b
	jr nz, UpdateNonPlayerSprite.unequal
	jp DoScriptedNPCMovement
UpdateNonPlayerSprite.unequal
	jp UpdateNPCSprite

; This detects if the current sprite (whose offset is at hCurrentSpriteOffset)
; is going to collide with another sprite by looping over the other sprites.
; The current sprite's offset will be labelled with i (e.g. i#SPRITESTATEDATA1_PICTUREID).
; The loop sprite's offset will labelled with j (e.g. j#SPRITESTATEDATA1_PICTUREID).
;
; Note that the Y coordinate of the sprite (in [k#SPRITESTATEDATA1_YPIXELS])
; is one of the following 9 values when the sprite is aligned with the grid:
; $fc, $0c, $1c, $2c, ..., $7c.
; The reason that 4 is added below to the coordinate is to make it align with a
; multiple of $10 to make comparisons easier.
DetectCollisionBetweenSprites:
	nop

	ld h, hibyte(wSpriteStateData1)
	ldh a, [lobyte(hCurrentSpriteOffset)]
	add lobyte(wSpriteStateData1)
	ld l, a

	ld a, [hl] ; a = [i#SPRITESTATEDATA1_PICTUREID] (0 if slot is unused)
	and a ; is this sprite slot slot used?
	ret z ; return if not used

	ld a, l
	add 3
	ld l, a

	ld a, [hli] ; a = [i#SPRITESTATEDATA1_YSTEPVECTOR] (-1, 0, or 1)
	call SetSpriteCollisionValues

	ld a, [hli] ; a = [i#SPRITESTATEDATA1_YPIXELS]
	add 4 ; align with multiple of $10

; The effect of the following 3 lines is to
; add 7 to a if moving south or
; subtract 7 from a if moving north.
	add b
	and $f0
	or c

	ldh [lobyte(hCollidingSpriteTempYValue)], a ; y adjusted for direction of movement

	ld a, [hli] ; a = [i#SPRITESTATEDATA1_XSTEPVECTOR] (-1, 0, or 1)
	call SetSpriteCollisionValues
	ld a, [hl] ; a = [i#SPRITESTATEDATA1_XPIXELS]

; The effect of the following 3 lines is to
; add 7 to a if moving east or
; subtract 7 from a if moving west.
	add b
	and $f0
	or c

	ldh [lobyte(hCollidingSpriteTempXValue)], a ; x adjusted for direction of movement

	ld a, l
	add 7
	ld l, a

	xor a
	ld [hld], a ; zero [i#SPRITESTATEDATA1_0D] XXX what's this for?
	ld [hld], a ; zero [i#SPRITESTATEDATA1_COLLISIONDATA]

	ldh a, [lobyte(hCollidingSpriteTempXValue)]
	ld [hld], a ; [i#SPRITESTATEDATA1_XADJUSTED]
	ldh a, [lobyte(hCollidingSpriteTempYValue)]
	ld [hl], a ; [i#SPRITESTATEDATA1_YADJUSTED]

	xor a ; zero the loop counter

DetectCollisionBetweenSprites.loop
	ldh [lobyte(hCollidingSpriteOffset)], a
	swap a
	ld e, a
	ldh a, [lobyte(hCurrentSpriteOffset)]
	cp e ; does the loop sprite match the current sprite?
	jp z, DetectCollisionBetweenSprites.next ; go to the next sprite if they match

	ld d, h
	ld a, [de] ; a = [j#SPRITESTATEDATA1_PICTUREID] (0 if slot is unused)
	and a ; is this sprite slot slot used?
	jp z, DetectCollisionBetweenSprites.next ; go the next sprite if not used

	inc e
	inc e
	ld a, [de] ; a = [j#SPRITESTATEDATA1_IMAGEINDEX] ($ff means the sprite is offscreen)
	inc a
	jp z, DetectCollisionBetweenSprites.next ; go the next sprite if offscreen

	ldh a, [lobyte(hCurrentSpriteOffset)]
	add 10
	ld l, a

	inc e
	ld a, [de] ; a = [j#SPRITESTATEDATA1_YSTEPVECTOR]
	call SetSpriteCollisionValues

	inc e
	ld a, [de] ; a = [j#SPRITESTATEDATA1_YPIXELS]
	add 4 ; align with multiple of $10

; The effect of the following 3 lines is to
; add 7 to a if moving south or
; subtract 7 from a if moving north.
	add b
	and $f0
	or c

	sub [hl] ; subtract [i#SPRITESTATEDATA1_YADJUSTED] from [j#SPRITESTATEDATA1_YADJUSTED]

; calculate the absolute value of the difference to get the distance
	jr nc, DetectCollisionBetweenSprites.noCarry1
	cpl
	inc a
DetectCollisionBetweenSprites.noCarry1
	ldh [lobyte(hCollidingSpriteTempYValue)], a ; store the distance between the two sprites' adjusted Y values

; Use the carry flag set by the above subtraction to determine which sprite's
; Y coordinate is larger. This information is used later to set
; [i#SPRITESTATEDATA1_COLLISIONDATA].
; The following 5 lines set the lowest 2 bits of c, which are later shifted left by 2.
; If sprite i's Y is larger, set lowest 2 bits of c to 10.
; If sprite j's Y is larger or both are equal, set lowest 2 bits of c to 01.
	push af
	rl c
	pop af
	ccf
	rl c

; If sprite i's delta Y is 0, then b = 7, else b = 9.
	ld b, 7
	ld a, [hl] ; a = [i#SPRITESTATEDATA1_YADJUSTED]
	and $f
	jr z, DetectCollisionBetweenSprites.next1
	ld b, 9

DetectCollisionBetweenSprites.next1
	ldh a, [lobyte(hCollidingSpriteTempYValue)] ; a = distance between adjusted Y coordinates
	sub b
	ldh [lobyte(hCollidingSpriteAdjustedDistance)], a
	ld a, b
	ldh [lobyte(hCollidingSpriteTempYValue)], a ; store 7 or 9 depending on sprite i's delta Y
	jr c, DetectCollisionBetweenSprites.checkXDistance

; If sprite j's delta Y is 0, then b = 7, else b = 9.
	ld b, 7
	dec e
	ld a, [de] ; a = [j#SPRITESTATEDATA1_YSTEPVECTOR]
	inc e
	and a
	jr z, DetectCollisionBetweenSprites.next2
	ld b, 9

DetectCollisionBetweenSprites.next2
	ldh a, [lobyte(hCollidingSpriteAdjustedDistance)]
	sub b ; adjust distance using sprite j's direction
	jr z, DetectCollisionBetweenSprites.checkXDistance
	jr nc, DetectCollisionBetweenSprites.next ; go to next sprite if distance is still positive after both adjustments

DetectCollisionBetweenSprites.checkXDistance
	inc e
	inc l
	ld a, [de] ; a = [j#SPRITESTATEDATA1_XSTEPVECTOR]

	push bc

	call SetSpriteCollisionValues
	inc e
	ld a, [de] ; a = [j#SPRITESTATEDATA1_XPIXELS]

; The effect of the following 3 lines is to
; add 7 to a if moving east or
; subtract 7 from a if moving west.
	add b
	and $f0
	or c

	pop bc

	sub [hl] ; subtract [i#SPRITESTATEDATA1_XADJUSTED] from [j#SPRITESTATEDATA1_XADJUSTED]

; calculate the absolute value of the difference to get the distance
	jr nc, DetectCollisionBetweenSprites.noCarry2
	cpl
	inc a
DetectCollisionBetweenSprites.noCarry2
	ldh [lobyte(hCollidingSpriteTempXValue)], a ; store the distance between the two sprites' adjusted X values

; Use the carry flag set by the above subtraction to determine which sprite's
; X coordinate is larger. This information is used later to set
; [i#SPRITESTATEDATA1_COLLISIONDATA].
; The following 5 lines set the lowest 2 bits of c.
; If sprite i's X is larger, set lowest 2 bits of c to 10.
; If sprite j's X is larger or both are equal, set lowest 2 bits of c to 01.
	push af
	rl c
	pop af
	ccf
	rl c

; If sprite i's delta X is 0, then b = 7, else b = 9.
	ld b, 7
	ld a, [hl] ; a = [i#SPRITESTATEDATA1_XADJUSTED]
	and $f
	jr z, DetectCollisionBetweenSprites.next3
	ld b, 9

DetectCollisionBetweenSprites.next3
	ldh a, [lobyte(hCollidingSpriteTempXValue)] ; a = distance between adjusted X coordinates
	sub b
	ldh [lobyte(hCollidingSpriteAdjustedDistance)], a
	ld a, b
	ldh [lobyte(hCollidingSpriteTempXValue)], a ; store 7 or 9 depending on sprite i's delta X
	jr c, DetectCollisionBetweenSprites.collision

; If sprite j's delta X is 0, then b = 7, else b = 9.
	ld b, 7
	dec e
	ld a, [de] ; a = [j#SPRITESTATEDATA1_XSTEPVECTOR]
	inc e
	and a
	jr z, DetectCollisionBetweenSprites.next4
	ld b, 9

DetectCollisionBetweenSprites.next4
	ldh a, [lobyte(hCollidingSpriteAdjustedDistance)]
	sub b ; adjust distance using sprite j's direction
	jr z, DetectCollisionBetweenSprites.collision
	jr nc, DetectCollisionBetweenSprites.next ; go to next sprite if distance is still positive after both adjustments

DetectCollisionBetweenSprites.collision
	ldh a, [lobyte(hCollidingSpriteTempXValue)] ; a = 7 or 9 depending on sprite i's delta X
	ld b, a
	ldh a, [lobyte(hCollidingSpriteTempYValue)] ; a = 7 or 9 depending on sprite i's delta Y
	inc l

; If delta X isn't 0 and delta Y is 0, then b = %0011, else b = %1100.
; (note that normally if delta X isn't 0, then delta Y must be 0 and vice versa)
	cp b
	jr c, DetectCollisionBetweenSprites.next5
	ld b, %1100
	jr DetectCollisionBetweenSprites.next6
DetectCollisionBetweenSprites.next5
	ld b, %0011

DetectCollisionBetweenSprites.next6
	ld a, c ; c has 2 bits set (one of bits 0-1 is set for the X axis and one of bits 2-3 for the Y axis)
	and b ; we select either the bit in bits 0-1 or bits 2-3 based on the calculation immediately above
	or [hl] ; or with existing collision direction bits in [i#SPRITESTATEDATA1_COLLISIONDATA]
	ld [hl], a ; store new value
	ld a, c ; useless code because a is overwritten before being used again

; set bit in [i#SPRITESTATEDATA1_0E] or [i#SPRITESTATEDATA1_0F]
; to indicate which sprite the collision occurred with
	inc l
	inc l
	ldh a, [lobyte(hCollidingSpriteOffset)]
	ld de, SpriteCollisionBitTable
	add a
	add e
	ld e, a
	jr nc, DetectCollisionBetweenSprites.noCarry3
	inc d
DetectCollisionBetweenSprites.noCarry3
	ld a, [de]
	or [hl]
	ld [hli], a
	inc de
	ld a, [de]
	or [hl]
	ld [hl], a

DetectCollisionBetweenSprites.next
	ldh a, [lobyte(hCollidingSpriteOffset)]
	inc a
	cp $10
	jp nz, DetectCollisionBetweenSprites.loop
	ret

; takes delta X or delta Y in a
; b = delta X/Y
; c = 0 if delta X/Y is 0
; c = 7 if delta X/Y is 1
; c = 9 if delta X/Y is -1
SetSpriteCollisionValues:
	and a
	ld b, 0
	ld c, 0
	jr z, SetSpriteCollisionValues.done
	ld c, 9
	cp -1
	jr z, SetSpriteCollisionValues.ok
	ld c, 7
	ld a, 0
SetSpriteCollisionValues.ok
	ld b, a
SetSpriteCollisionValues.done
	ret

SpriteCollisionBitTable:
.REPEAT $10 INDEX n
	bigdw 1 << n
.ENDR
