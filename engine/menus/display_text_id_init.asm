; function that performs initialization for DisplayTextID
DisplayTextIDInit:
	xor a
	ld [wListMenuID], a
	ld a, [wAutoTextBoxDrawingControl]
	bit BIT_NO_AUTO_TEXT_BOX, a
	jr nz, DisplayTextIDInit.skipDrawingTextBoxBorder
	ldh a, [lobyte(hTextID)]
	and a
	jr nz, DisplayTextIDInit.notStartMenu
; if text ID is 0 (i.e. the start menu)
; Note that the start menu text border is also drawn in the function directly
; below this, so this seems unnecessary.
	CheckEvent EVENT_GOT_POKEDEX
; start menu with pokedex
	hlcoord 10, 0
	ld b, $0e
	ld c, $08
	jr nz, DisplayTextIDInit.drawTextBoxBorder
; start menu without pokedex
	hlcoord 10, 0
	ld b, $0c
	ld c, $08
	jr DisplayTextIDInit.drawTextBoxBorder
; if text ID is not 0 (i.e. not the start menu) then do a standard dialogue text box
DisplayTextIDInit.notStartMenu
	hlcoord 0, 12
	ld b, $04
	ld c, $12
DisplayTextIDInit.drawTextBoxBorder
	call TextBoxBorder
DisplayTextIDInit.skipDrawingTextBoxBorder
	ld hl, wFontLoaded
	set BIT_FONT_LOADED, [hl]
	ld hl, wMiscFlags
	bit BIT_NO_SPRITE_UPDATES, [hl]
	res BIT_NO_SPRITE_UPDATES, [hl]
	jr nz, DisplayTextIDInit.skipMovingSprites
	call UpdateSprites
DisplayTextIDInit.skipMovingSprites
; loop to copy [x#SPRITESTATEDATA1_FACINGDIRECTION] to
; [x#SPRITESTATEDATA2_ORIGFACINGDIRECTION] for each non-player sprite
; this is done because when you talk to an NPC, they turn to look your way
; the original direction they were facing must be restored after the dialogue is over
	ld hl, wSprite01StateData1FacingDirection
	ld c, NUM_SPRITESTATEDATA_STRUCTS - 1
	ld de, SPRITESTATEDATA1_LENGTH
DisplayTextIDInit.spriteFacingDirectionCopyLoop
	ld a, [hl] ; x#SPRITESTATEDATA1_FACINGDIRECTION
	inc h
	ld [hl], a ; [x#SPRITESTATEDATA2_ORIGFACINGDIRECTION]
	dec h
	add hl, de
	dec c
	jr nz, DisplayTextIDInit.spriteFacingDirectionCopyLoop
; loop to force all the sprites in the middle of animation to stand still
; (so that they don't like they're frozen mid-step during the dialogue)
	ld hl, wSpritePlayerStateData1ImageIndex
	ld de, SPRITESTATEDATA1_LENGTH
	.ASSERT ((NUM_SPRITESTATEDATA_STRUCTS)-(SPRITESTATEDATA1_LENGTH)) < 1 && ((NUM_SPRITESTATEDATA_STRUCTS)-(SPRITESTATEDATA1_LENGTH)) > -1
	ld c, e
DisplayTextIDInit.spriteStandStillLoop
	ld a, [hl]
	cp $ff ; is the sprite visible?
	jr z, DisplayTextIDInit.nextSprite
; if it is visible
	and $fc
	ld [hl], a
DisplayTextIDInit.nextSprite
	add hl, de
	dec c
	jr nz, DisplayTextIDInit.spriteStandStillLoop
	ld b, hibyte(vBGMap1)
	call CopyScreenTileBufferToVRAM ; transfer background in WRAM to VRAM
	xor a
	ldh [lobyte(hWY)], a ; put the window on the screen
	call LoadFontTilePatterns
	ld a, $01
	ldh [lobyte(hAutoBGTransferEnabled)], a ; enable continuous WRAM to VRAM transfer each V-blank
	ret
