BookOrSculptureText:
	text_asm
	ld hl, PokemonBooksText
	ld a, [wCurMapTileset]
	cp MANSION ; Celadon Mansion tileset
	jr nz, BookOrSculptureText.ok
	lda_coord 8, 6
	cp $38
	jr nz, BookOrSculptureText.ok
	ld hl, DiglettSculptureText
BookOrSculptureText.ok
	call PrintText
	jp TextScriptEnd

PokemonBooksText:
	text_far WLA_GLOBAL_PokemonBooksText
	text_end

DiglettSculptureText:
	text_far WLA_GLOBAL_DiglettSculptureText
	text_end
