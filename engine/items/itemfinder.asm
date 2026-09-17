HiddenItemNear:
	ld hl, HiddenItemCoords
	ld b, 0
HiddenItemNear.loop
	ld de, 3
	ld a, [wCurMap]
	call IsInRestOfArray
	ret nc ; return if current map has no hidden items
	push bc
	push hl
	ld hl, wObtainedHiddenItemsFlags
	ld c, b
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	pop hl
	pop bc
	inc b
	and a
	inc hl
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	jr nz, HiddenItemNear.loop ; if the item has already been obtained
; check if the item is within 4-5 * TILE_SIZE (depending on the direction of item)
	ld a, [wYCoord]
	call Sub5ClampTo0
	cp d
	jr nc, HiddenItemNear.loop
	ld a, [wYCoord]
	add 4
	cp d
	jr c, HiddenItemNear.loop
	ld a, [wXCoord]
	call Sub5ClampTo0
	cp e
	jr nc, HiddenItemNear.loop
	ld a, [wXCoord]
	add 5
	cp e
	jr c, HiddenItemNear.loop
	scf
	ret

Sub5ClampTo0:
; subtract 5 but clamp to 0
	sub 5
	cp $f0
	ret c
	xor a
	ret
