LoadSpinnerArrowTiles:
	ld a, [wSpritePlayerStateData1ImageIndex]
	srl a
	srl a
	ld hl, SpinnerPlayerFacingDirections
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	ld [wSpritePlayerStateData1ImageIndex], a
	ld a, [wCurMapTileset]
	cp FACILITY
	ld hl, FacilitySpinnerArrows
	jr z, LoadSpinnerArrowTiles.gotSpinnerArrows
	ld hl, GymSpinnerArrows
LoadSpinnerArrowTiles.gotSpinnerArrows
	ld a, [wSimulatedJoypadStatesIndex]
	bit 0, a ; even or odd?
	jr nz, LoadSpinnerArrowTiles.alternateGraphics
	ld de, 6 * 4
	add hl, de
LoadSpinnerArrowTiles.alternateGraphics
	ld a, $4
	ld bc, $0
LoadSpinnerArrowTiles.loop
	push af
	push hl
	push bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CopyVideoData
	pop bc
	ld a, $6
	add c
	ld c, a
	pop hl
	pop af
	dec a
	jr nz, LoadSpinnerArrowTiles.loop
	ret

.INCLUDE "data/tilesets/spinner_tiles.asm"

SpinnerPlayerFacingDirections:
; This isn't the order of the facing directions.  Rather, it's a list of
; the facing directions that come next. For example, when the player is
; facing down (00), the next facing direction is left (08).
	.DB SPRITE_FACING_LEFT  ; down -> left
	.DB SPRITE_FACING_RIGHT ; up -> right
	.DB SPRITE_FACING_UP    ; left -> up
	.DB SPRITE_FACING_DOWN  ; right -> down

; these tiles are the animation for the tiles that push the player in dungeons like Rocket HQ
SpinnerArrowAnimTiles:
	.INCBIN "gfx/overworld/spinners.2bpp"
