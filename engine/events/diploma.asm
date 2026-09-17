.DEFINE CIRCLE_TILE_ID $70

DisplayDiploma:
	call SaveScreenTilesToBuffer2
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	xor a
	ld [wUpdateSpritesEnabled], a
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	call DisableLCD
	ld hl, CircleTile
	ld de, vChars2 + TILE_SIZE * CIRCLE_TILE_ID
	ld bc, TILE_SIZE
	ld a, bank(CircleTile)
	call FarCopyData2
	hlcoord 0, 0
	lb "bc", 16, 18
	predef Diploma_TextBoxBorder

	ld hl, DiplomaTextPointersAndCoords
	ld c, $5
DisplayDiploma.placeTextLoop
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call PlaceString
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, DisplayDiploma.placeTextLoop
	hlcoord 10, 4
	ld de, wPlayerName
	call PlaceString
	farcall DrawPlayerCharacter

; Move the player 33 pixels right and set the priority bit so he appears
; behind the background layer.
	ld hl, wShadowOAMSprite00XCoord
	lb "bc", $80, $28
DisplayDiploma.adjustPlayerGfxLoop
	ld a, [hl] ; X
	add 33
	ld [hli], a
	inc hl
	ld a, b
	ld [hli], a ; attributes
	inc hl
	dec c
	jr nz, DisplayDiploma.adjustPlayerGfxLoop

	call EnableLCD
	farcall LoadTrainerInfoTextBoxTiles
	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	call Delay3
	call GBPalNormal
	ld a, $90
	ldh [lobyte(rOBP0)], a
	call WaitForTextScrollButtonPress
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call Delay3
	jp GBPalNormal

UnusedPlayerNameLengthFunc:
; Unused function that performs bc = -(player name's length)
; leftover from the JPN versions
	ld hl, wPlayerName
	lb "bc", $ff, $00
UnusedPlayerNameLengthFunc.loop
	ld a, [hli]
	cp $50
	ret z
	dec c
	jr UnusedPlayerNameLengthFunc.loop

.MACRO diploma_text
	.DW \3
	dwcoord \1, \2
.ENDM

DiplomaTextPointersAndCoords:
	; x, y, text
	diploma_text  5,  2, DiplomaText
	diploma_text  3,  4, DiplomaPlayer
	diploma_text 15,  4, DiplomaEmptyText
	diploma_text  2,  6, DiplomaCongrats
	diploma_text  9, 16, DiplomaGameFreak

DiplomaText:
		.DB CIRCLE_TILE_ID
		.STRINGMAP pokemon, "Diploma"
		.DB CIRCLE_TILE_ID
		.STRINGMAP pokemon, "@"

DiplomaPlayer:
		.STRINGMAP pokemon, "Player@"

DiplomaEmptyText:
		.STRINGMAP pokemon, "@"

DiplomaCongrats:
		.STRINGMAP pokemon, "Congrats! This"
	next "diploma certifies"
	next "that you have"
	next "completed your"
	next "#DEX.@"

DiplomaGameFreak:
		.STRINGMAP pokemon, "GAME FREAK@"
