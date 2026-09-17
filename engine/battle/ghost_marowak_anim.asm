MarowakAnim:
; animate the ghost being unveiled as a Marowak
	ld a, $e4
	ldh [lobyte(rOBP1)], a
	call CopyMonPicFromBGToSpriteVRAM ; cover the BG ghost pic with a sprite ghost pic that looks the same
; now that the ghost pic is being displayed using sprites, clear the ghost pic from the BG tilemap
	hlcoord 12, 0
	lb "bc", 7, 7
	call ClearScreenArea
	call Delay3
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a ; disable BG transfer so we don't see the Marowak too soon
; replace ghost pic with Marowak in BG
	ld a, RESTLESS_SOUL
	ld [wChangeMonPicEnemyTurnSpecies], a
	ld a, $1
	ldh [lobyte(hWhoseTurn)], a
	callfar ChangeMonPic
 ; alternate between black and light gray 8 times.
 ; this makes the ghost's body appear to flash
	ld d, $80
	call FlashSprite8Times
MarowakAnim.fadeOutGhostLoop
	ld c, 10
	call DelayFrames
	ldh a, [lobyte(rOBP1)]
	sla a
	sla a
	ldh [lobyte(rOBP1)], a
	jr nz, MarowakAnim.fadeOutGhostLoop
	call ClearSprites
	call CopyMonPicFromBGToSpriteVRAM ; copy Marowak pic from BG to sprite VRAM
	ld b, $e4
MarowakAnim.fadeInMarowakLoop
	ld c, 10
	call DelayFrames
	ldh a, [lobyte(rOBP1)]
	srl b
	rra
	srl b
	rra
	ldh [lobyte(rOBP1)], a
	ld a, b
	and a
	jr nz, MarowakAnim.fadeInMarowakLoop
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a ; enable BG transfer so the BG Marowak pic will be visible after the sprite one is cleared
	call Delay3
	jp ClearSprites

; copies a mon pic's from background VRAM to sprite VRAM and sets up OAM
CopyMonPicFromBGToSpriteVRAM:
	ld de, vFrontPic
	ld hl, vSprites
	ld bc, PIC_SIZE
	call CopyVideoData
	ld a, $10
	ld [wBaseCoordY], a
	ld a, $70
	ld [wBaseCoordX], a
	ld hl, wShadowOAM
	lb "bc", 6, 6
	ld d, $8
CopyMonPicFromBGToSpriteVRAM.oamLoop
	push bc
	ld a, [wBaseCoordY]
	ld e, a
CopyMonPicFromBGToSpriteVRAM.oamInnerLoop
	ld a, e
	add $8
	ld e, a
	ld [hli], a
	ld a, [wBaseCoordX]
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, OAM_PAL1
	ld [hli], a
	inc d
	dec c
	jr nz, CopyMonPicFromBGToSpriteVRAM.oamInnerLoop
	inc d
	ld a, [wBaseCoordX]
	add $8
	ld [wBaseCoordX], a
	pop bc
	dec b
	jr nz, CopyMonPicFromBGToSpriteVRAM.oamLoop
	ret
