PrepareOAMData:
; Determine OAM data for currently visible
; sprites and write it to wShadowOAM.

	ld a, [wUpdateSpritesEnabled]
	dec a
	jr z, PrepareOAMData.updateEnabled

	cp -1
	ret nz
	ld [wUpdateSpritesEnabled], a
	jp HideSprites

PrepareOAMData.updateEnabled
	xor a
	ldh [lobyte(hOAMBufferOffset)], a

PrepareOAMData.spriteLoop
	ldh [lobyte(hSpriteOffset2)], a

	ld d, hibyte(wSpriteStateData1)
	ldh a, [lobyte(hSpriteOffset2)]
	ld e, a
	ld a, [de] ; [x#SPRITESTATEDATA1_PICTUREID]
	and a
	jp z, PrepareOAMData.nextSprite

	inc e
	inc e
	ld a, [de] ; [x#SPRITESTATEDATA1_IMAGEINDEX]
	ld [wSavedSpriteImageIndex], a
	cp $ff ; off-screen (don't draw)
	jr nz, PrepareOAMData.visible

	call GetSpriteScreenXY
	jr PrepareOAMData.nextSprite

PrepareOAMData.visible
	cp $a0 ; is the sprite unchanging like an item ball or boulder?
	jr c, PrepareOAMData.usefacing

; unchanging
	and $f
	add $10 ; skip to the second half of the table which doesn't account for facing direction
	jr PrepareOAMData.next

PrepareOAMData.usefacing
	and $f

PrepareOAMData.next
	ld l, a

; get sprite priority
	push de
	inc d
	ld a, e
	add $5
	ld e, a
	ld a, [de] ; [x#SPRITESTATEDATA2_GRASSPRIORITY]
	and $80
	ldh [lobyte(hSpritePriority)], a ; temp store sprite priority
	pop de

; read the entry from the table
	ld h, 0
	ld bc, SpriteFacingAndAnimationTable
	add hl, hl
	add hl, hl
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a

	call GetSpriteScreenXY

	ldh a, [lobyte(hOAMBufferOffset)]
	ld e, a
	ld d, hibyte(wShadowOAM)

PrepareOAMData.tileLoop
	ldh a, [lobyte(hSpriteScreenY)]   ; temp for sprite Y position
	add $10                  ; Y=16 is top of screen (Y=0 is invisible)
	add [hl]                 ; add Y offset from table
	ld [de], a               ; write new sprite OAM Y position
	inc hl
	ldh a, [lobyte(hSpriteScreenX)]   ; temp for sprite X position
	add $8                   ; X=8 is left of screen (X=0 is invisible)
	add [hl]                 ; add X offset from table
	inc e
	ld [de], a               ; write new sprite OAM X position
	inc e
	ld a, [bc]               ; read pattern number offset (accommodates orientation (offset 0,4 or 8) and animation (offset 0 or $80))
	inc bc
	push bc
	ld b, a

	ld a, [wSavedSpriteImageIndex]
	swap a                   ; high nybble determines sprite used (0 is always player sprite, next are some npcs)
	and $f

	; Sprites $a and $b have one face (and therefore 4 * TILE_SIZE instead of 12).
	; As a result, sprite $b's tile offset is less than normal.
	cp $b
	jr nz, PrepareOAMData.notFourTileSprite
	ld a, $a * 12 + 4
	jr PrepareOAMData.next2

PrepareOAMData.notFourTileSprite
	; a *= 12
	sla a
	sla a
	ld c, a
	sla a
	add c

PrepareOAMData.next2
	add b ; add the tile offset from the table (based on frame and facing direction)
	pop bc
	ld [de], a ; tile id
	inc hl
	inc e
	ld a, [hl]
	bit BIT_SPRITE_UNDER_GRASS, a
	jr z, PrepareOAMData.skipPriority
	ldh a, [lobyte(hSpritePriority)]
	or [hl]
PrepareOAMData.skipPriority
	inc hl
	ld [de], a
	inc e
	bit BIT_END_OF_OAM_DATA, a
	jr z, PrepareOAMData.tileLoop

	ld a, e
	ldh [lobyte(hOAMBufferOffset)], a

PrepareOAMData.nextSprite
	ldh a, [lobyte(hSpriteOffset2)]
	add $10
	cp lobyte($100)
	jp nz, PrepareOAMData.spriteLoop

	; Clear unused OAM.
	ldh a, [lobyte(hOAMBufferOffset)]
	ld l, a
	ld h, hibyte(wShadowOAM)
	ld de, OBJ_SIZE
	ld b, SCREEN_HEIGHT_PX + OAM_Y_OFS
	ld a, [wMovementFlags]
	bit BIT_LEDGE_OR_FISHING, a
	ld a, lobyte(wShadowOAMEnd)
	jr z, PrepareOAMData.clear

; Don't clear the last 4 entries because they are used for the shadow in the
; jumping down ledge animation and the rod in the fishing animation.
	ld a, lobyte(wShadowOAMSprite36)

PrepareOAMData.clear
	cp l
	ret z
	ld [hl], b
	add hl, de
	jr PrepareOAMData.clear

GetSpriteScreenXY:
	inc e
	inc e
	ld a, [de] ; [x#SPRITESTATEDATA1_YPIXELS]
	ldh [lobyte(hSpriteScreenY)], a
	inc e
	inc e
	ld a, [de] ; [x#SPRITESTATEDATA1_XPIXELS]
	ldh [lobyte(hSpriteScreenX)], a
	ld a, 4
	add e
	ld e, a
	ldh a, [lobyte(hSpriteScreenY)]
	add 4
	and $f0
	ld [de], a ; [x#SPRITESTATEDATA1_YADJUSTED]
	inc e
	ldh a, [lobyte(hSpriteScreenX)]
	and $f0
	ld [de], a  ; [x#SPRITESTATEDATA1_XADJUSTED]
	ret
