; prints text for bookshelves in buildings without sign events
PrintBookshelfText:
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	jr nz, PrintBookshelfText.noMatch
; facing up
	ld a, [wCurMapTileset]
	ld b, a
	lda_coord 8, 7
	ld c, a
	ld hl, BookshelfTileIDs
PrintBookshelfText.loop
	ld a, [hli]
	cp $ff
	jr z, PrintBookshelfText.noMatch
	cp b
	jr nz, PrintBookshelfText.nextBookshelfEntry1
	ld a, [hli]
	cp c
	jr nz, PrintBookshelfText.nextBookshelfEntry2
	ld a, [hl]
	push af
	call EnableAutoTextBoxDrawing
	pop af
	call PrintPredefTextID
	xor a
	ldh [lobyte(hInteractedWithBookshelf)], a
	ret
PrintBookshelfText.nextBookshelfEntry1
	inc hl
PrintBookshelfText.nextBookshelfEntry2
	inc hl
	jr PrintBookshelfText.loop
PrintBookshelfText.noMatch
	ld a, $ff
	ldh [lobyte(hInteractedWithBookshelf)], a
	farjp PrintCardKeyText

.INCLUDE "data/tilesets/bookshelf_tile_ids.asm"
