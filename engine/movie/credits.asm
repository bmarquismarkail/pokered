HallOfFamePC:
	farcall AnimateHallOfFame
	call ClearScreen
	ld c, 100
	call DelayFrames
	call DisableLCD
	ld hl, vFont
	ld bc, ($80 * TILE_SIZE) / 2
	call ShiftFontColorIndex
	ld hl, vChars2 + TILE_SIZE * $60
	ld bc, ($20 * TILE_SIZE) / 2
	call ShiftFontColorIndex
	ld hl, vChars2 + TILE_SIZE * $7e
	ld bc, TILE_SIZE
	ld a, $ff ; solid black
	call FillMemory
	hlcoord 0, 0
	call FillFourRowsWithBlack
	hlcoord 0, 14
	call FillFourRowsWithBlack
	ld a, %11000000
	ldh [lobyte(rBGP)], a
	call EnableLCD
	ld a, SFX_STOP_ALL_MUSIC
	call PlaySoundWaitForCurrent
	ld c, bank(Music_Credits)
	ld a, MUSIC_CREDITS
	call PlayMusic
	ld c, 128
	call DelayFrames
	xor a
	ld [wUnusedCreditsByte], a ; not read
	ld [wNumCreditsMonsDisplayed], a
	jp Credits

FadeInCredits:
	ld hl, HoFGBPalettes
	ld b, 4
FadeInCredits.loop
	ld a, [hli]
	ldh [lobyte(rBGP)], a
	ld c, 5
	call DelayFrames
	dec b
	jr nz, FadeInCredits.loop
	ret

DisplayCreditsMon:
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call SaveScreenTilesToBuffer1
	call FillMiddleOfScreenWithWhite

	; display the next monster from CreditsMons
	ld hl, wNumCreditsMonsDisplayed
	ld c, [hl] ; how many monsters have we displayed so far?
	inc [hl]
	ld b, 0
	ld hl, CreditsMons
	add hl, bc ; go that far in the list of monsters and get the next one
	ld a, [hl]
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	hlcoord 8, 6
	call GetMonHeader
	call LoadFrontSpriteByMonIndex
	ld hl, vBGMap0 + $c
	call CreditsCopyTileMapToVRAM
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call LoadScreenTilesFromBuffer1
	ld hl, vBGMap0
	call CreditsCopyTileMapToVRAM
	ld a, $A7
	ldh [lobyte(rWX)], a
	ld hl, vBGMap1
	call CreditsCopyTileMapToVRAM
	call FillMiddleOfScreenWithWhite
	ld a, %11111100 ; make the mon a black silhouette
	ldh [lobyte(rBGP)], a

; scroll the mon left by one tile 7 times
	ld bc, 7
DisplayCreditsMon.scrollLoop1
	call ScrollCreditsMonLeft
	dec c
	jr nz, DisplayCreditsMon.scrollLoop1

; scroll the mon left by one tile 20 times
; This time, we have to move the window left too in order to hide the text that
; is wrapping around to the right side of the screen.
	ld c, 20
DisplayCreditsMon.scrollLoop2
	call ScrollCreditsMonLeft
	ldh a, [lobyte(rWX)]
	sub 8
	ldh [lobyte(rWX)], a
	dec c
	jr nz, DisplayCreditsMon.scrollLoop2

	xor a
	ldh [lobyte(hWY)], a
	ld a, %11000000
	ldh [lobyte(rBGP)], a
	ret

.INCLUDE "data/credits/credits_mons.asm"

ScrollCreditsMonLeft:
	ld h, b
	ld l, $20
	call ScrollCreditsMonLeft_SetSCX
	ld h, $0
	ld l, $70
	call ScrollCreditsMonLeft_SetSCX
	ld a, b
	add $8
	ld b, a
	ret

ScrollCreditsMonLeft_SetSCX:
	ldh a, [lobyte(rLY)]
	cp l
	jr nz, ScrollCreditsMonLeft_SetSCX
	ld a, h
	ldh [lobyte(rSCX)], a
ScrollCreditsMonLeft_SetSCX.loop
	ldh a, [lobyte(rLY)]
	cp h
	jr z, ScrollCreditsMonLeft_SetSCX.loop
	ret

HoFGBPalettes:
	dc 3, 0, 0, 0
	dc 3, 1, 0, 0
	dc 3, 2, 0, 0
	dc 3, 3, 0, 0

CreditsCopyTileMapToVRAM:
	ld a, l
	ldh [lobyte(hAutoBGTransferDest)], a
	ld a, h
	ldh [lobyte(hAutoBGTransferDest + 1)], a
	ld a, 1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	jp Delay3

ShiftFontColorIndex:
; Zero every second byte at hl, writing a total of bc bytes.
; When used on VRAM font characters that contain only black and white shades,
; it shifts the color index: black -> light gray, allowing palette-controlled
; text fade-in during the Credits roll, while the black bars remain solid.
	ld [hl], 0
	inc hl
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, ShiftFontColorIndex
	ret

FillFourRowsWithBlack:
	ld bc, SCREEN_WIDTH * 4
	ld a, $7e
	jp FillMemory

FillMiddleOfScreenWithWhite:
	hlcoord 0, 4
	ld bc, SCREEN_WIDTH * 10
	ld a, $7f
	jp FillMemory

Credits:
	ld de, CreditsOrder
	push de
Credits.nextCreditsScreen
	pop de
	hlcoord 9, 6
	push hl
	call FillMiddleOfScreenWithWhite
	pop hl
Credits.nextCreditsCommand
	ld a, [de]
	inc de
	push de
	cp CRED_TEXT_FADE_MON
	jr z, Credits.fadeInTextAndShowMon
	cp CRED_TEXT_MON
	jr z, Credits.showTextAndShowMon
	cp CRED_TEXT_FADE
	jr z, Credits.fadeInText
	cp CRED_TEXT
	jr z, Credits.showText
	cp CRED_COPYRIGHT
	jr z, Credits.showCopyrightText
	cp CRED_THE_END
	jr z, Credits.showTheEnd
	push hl
	push hl
	ld hl, CreditsTextPointers
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	inc de
	ld c, a
	ld b, -1
	pop hl
	add hl, bc
	call PlaceString
	pop hl
	ld bc, SCREEN_WIDTH * 2
	add hl, bc
	pop de
	jr Credits.nextCreditsCommand
Credits.fadeInTextAndShowMon
	call FadeInCredits
	ld c, 90
	jr Credits.next1
Credits.showTextAndShowMon
	ld c, 110
Credits.next1
	call DelayFrames
	call DisplayCreditsMon
	jr Credits.nextCreditsScreen
Credits.fadeInText
	call FadeInCredits
	ld c, 120
	jr Credits.next2
Credits.showText
	ld c, 140
Credits.next2
	call DelayFrames
	jr Credits.nextCreditsScreen
Credits.showCopyrightText
	push de
	farcall LoadCopyrightTiles
	pop de
	pop de
	jr Credits.nextCreditsCommand
Credits.showTheEnd
	ld c, 16
	call DelayFrames
	call FillMiddleOfScreenWithWhite
	pop de
	ld de, TheEndGfx
	ld hl, vChars2 + TILE_SIZE * $60
	lb "bc", bank(TheEndGfx), (TheEndGfxEnd - TheEndGfx) / TILE_SIZE
	call CopyVideoData
	hlcoord 4, 8
	ld de, TheEndTextString
	call PlaceString
	hlcoord 4, 9
	inc de
	call PlaceString
	jp FadeInCredits

TheEndTextString:
; "T H E  E N D"
		.DB $60
		.STRINGMAP pokemon, " "
		.DB $62
		.STRINGMAP pokemon, " "
		.DB $64
		.STRINGMAP pokemon, "  "
		.DB $64
		.STRINGMAP pokemon, " "
		.DB $66
		.STRINGMAP pokemon, " "
		.DB $68
		.STRINGMAP pokemon, "@"
		.DB $61
		.STRINGMAP pokemon, " "
		.DB $63
		.STRINGMAP pokemon, " "
		.DB $65
		.STRINGMAP pokemon, "  "
		.DB $65
		.STRINGMAP pokemon, " "
		.DB $67
		.STRINGMAP pokemon, " "
		.DB $69
		.STRINGMAP pokemon, "@"

.INCLUDE "data/credits/credits_order.asm"

.INCLUDE "data/credits/credits_text.asm"

TheEndGfx:
	.INCBIN "gfx/credits/the_end.2bpp"
TheEndGfxEnd:
