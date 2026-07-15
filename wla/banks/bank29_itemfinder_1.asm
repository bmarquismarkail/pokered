; Native WLA-DX form of engine/movie/credits.asm, engine/pokemon/status_ailments.asm, engine/items/itemfinder.asm.
.STRINGMAPTABLE pokemon "wla/pokemon.tbl"
HallOfFamePC:
	ld b, $1c
	ld hl, $41a0
	call Bankswitch
	call ClearScreen
	ld c, 100
	call DelayFrames
	call DisableLCD
	ld hl, vFont
	ld bc, (($80 * 16)) / 2
	call ShiftFontColorIndex
	ld hl, vChars2 + ($60) * 16
	ld bc, (($20 * 16)) / 2
	call ShiftFontColorIndex
	ld hl, vChars2 + ($7e) * 16
	ld bc, TILE_SIZE
	ld a, $ff ; solid black
	call FillMemory
	ld hl, wTileMap + (0 * 20) + 0
	call FillFourRowsWithBlack
	ld hl, wTileMap + (14 * 20) + 0
	call FillFourRowsWithBlack
	ld a, %11000000
	ldh (rBGP), a
	call EnableLCD
	ld a, SFX_STOP_ALL_MUSIC
	call PlaySoundWaitForCurrent
	ld c, $1f
	ld a, MUSIC_CREDITS
	call PlayMusic
	ld c, 128
	call DelayFrames
	xor a
	ld (wUnusedCreditsByte), a ; not read
	ld (wNumCreditsMonsDisplayed), a
	jp Credits

FadeInCredits:
	ld hl, HoFGBPalettes
	ld b, 4
FadeInCredits.loop:
	ld a, (HL+)
	ldh (rBGP), a
	ld c, 5
	call DelayFrames
	dec b
	jr nz, FadeInCredits.loop
	ret

DisplayCreditsMon:
	xor a
	ldh (hAutoBGTransferEnabled - $FF00), a
	call SaveScreenTilesToBuffer1
	call FillMiddleOfScreenWithWhite

	; display the next monster from CreditsMons
	ld hl, wNumCreditsMonsDisplayed
	ld c, (hl) ; how many monsters have we displayed so far?
	inc (hl)
	ld b, 0
	ld hl, CreditsMons
	add hl, bc ; go that far in the list of monsters and get the next one
	ld a, (hl)
	ld (wCurPartySpecies), a
	ld (wCurSpecies), a
	ld hl, wTileMap + (6 * 20) + 8
	call GetMonHeader
	call LoadFrontSpriteByMonIndex
	ld hl, vBGMap0 + $c
	call CreditsCopyTileMapToVRAM
	xor a
	ldh (hAutoBGTransferEnabled - $FF00), a
	call LoadScreenTilesFromBuffer1
	ld hl, vBGMap0
	call CreditsCopyTileMapToVRAM
	ld a, $A7
	ldh (rWX), a
	ld hl, vBGMap1
	call CreditsCopyTileMapToVRAM
	call FillMiddleOfScreenWithWhite
	ld a, %11111100 ; make the mon a black silhouette
	ldh (rBGP), a

; scroll the mon left by one tile 7 times
	ld bc, 7
DisplayCreditsMon.scrollLoop1:
	call ScrollCreditsMonLeft
	dec c
	jr nz, DisplayCreditsMon.scrollLoop1

; scroll the mon left by one tile 20 times
; This time, we have to move the window left too in order to hide the text that
; is wrapping around to the right side of the screen.
	ld c, 20
DisplayCreditsMon.scrollLoop2:
	call ScrollCreditsMonLeft
	ldh a, (rWX)
	sub 8
	ldh (rWX), a
	dec c
	jr nz, DisplayCreditsMon.scrollLoop2

	xor a
	ldh (hWY - $FF00), a
	ld a, %11000000
	ldh (rBGP), a
	ret

CreditsMons:
; one entry per CRED_TEXT_MON or CRED_TEXT_FADE_MON in CreditsOrder
	.DB VENUSAUR
	.DB ARBOK
	.DB RHYHORN
	.DB FEAROW
	.DB ABRA
	.DB GRAVELER
	.DB HITMONLEE
	.DB TANGELA
	.DB STARMIE
	.DB GYARADOS
	.DB DITTO
	.DB OMASTAR
	.DB VILEPLUME
	.DB NIDOKING
	.DB PARASECT

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
	ldh a, (rLY)
	cp l
	jr nz, ScrollCreditsMonLeft_SetSCX
	ld a, h
	ldh (rSCX), a
ScrollCreditsMonLeft_SetSCX.loop:
	ldh a, (rLY)
	cp h
	jr z, ScrollCreditsMonLeft_SetSCX.loop
	ret

HoFGBPalettes:
	.DB ((3) << 6) | ((0) << 4) | ((0) << 2) | (0)
	.DB ((3) << 6) | ((1) << 4) | ((0) << 2) | (0)
	.DB ((3) << 6) | ((2) << 4) | ((0) << 2) | (0)
	.DB ((3) << 6) | ((3) << 4) | ((0) << 2) | (0)

CreditsCopyTileMapToVRAM:
	ld a, l
	ldh (hAutoBGTransferDest - $FF00), a
	ld a, h
	ldh (hAutoBGTransferDest - $FF00 + 1), a
	ld a, 1
	ldh (hAutoBGTransferEnabled - $FF00), a
	jp Delay3

ShiftFontColorIndex:
; Zero every second byte at hl, writing a total of bc bytes.
; When used on VRAM font characters that contain only black and white shades,
; it shifts the color index: black -> light gray, allowing palette-controlled
; text fade-in during the Credits roll, while the black bars remain solid.
	ld (hl), 0
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
	ld hl, wTileMap + (4 * 20) + 0
	ld bc, SCREEN_WIDTH * 10
	ld a, $7f
	jp FillMemory

Credits:
	ld de, CreditsOrder
	push de
Credits.nextCreditsScreen:
	pop de
	ld hl, wTileMap + (6 * 20) + 9
	push hl
	call FillMiddleOfScreenWithWhite
	pop hl
Credits.nextCreditsCommand:
	ld a, (de)
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
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld a, (de)
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
Credits.fadeInTextAndShowMon:
	call FadeInCredits
	ld c, 90
	jr Credits.next1
Credits.showTextAndShowMon:
	ld c, 110
Credits.next1:
	call DelayFrames
	call DisplayCreditsMon
	jr Credits.nextCreditsScreen
Credits.fadeInText:
	call FadeInCredits
	ld c, 120
	jr Credits.next2
Credits.showText:
	ld c, 140
Credits.next2:
	call DelayFrames
	jr Credits.nextCreditsScreen
Credits.showCopyrightText:
	push de
	ld b, $01
	ld hl, $4541
	call Bankswitch
	pop de
	pop de
	jr Credits.nextCreditsCommand
Credits.showTheEnd:
	ld c, 16
	call DelayFrames
	call FillMiddleOfScreenWithWhite
	pop de
	ld de, TheEndGfx
	ld hl, vChars2 + ($60) * 16
	ld bc, (($1d) << 8) | ((TheEndGfxEnd - TheEndGfx) / TILE_SIZE)
	call CopyVideoData
	ld hl, wTileMap + (8 * 20) + 4
	ld de, TheEndTextString
	call PlaceString
	ld hl, wTileMap + (9 * 20) + 4
	inc de
	call PlaceString
	jp FadeInCredits

TheEndTextString:
; "T H E  E N D"
	.DB $60,$7f,$62,$7f,$64,$7f, $7f,$64,$7f,$66,$7f,$68,$50
	.DB $61,$7f,$63,$7f,$65,$7f, $7f,$65,$7f,$67,$7f,$69,$50

CreditsOrder:
; subsequent credits elements will be displayed on separate lines.
; CRED_TEXT, CRED_TEXT_FADE, CRED_TEXT_MON, and CRED_TEXT_FADE_MON are
; commands that are used to go to the next set of credits texts.
	.DB CRED_MON, CRED_VERSION, CRED_TEXT_FADE_MON
	.DB CRED_DIRECTOR, CRED_TAJIRI, CRED_TEXT_FADE_MON
	.DB CRED_PROGRAMMERS, CRED_TA_OOTA, CRED_MORIMOTO, CRED_TEXT_FADE
	.DB CRED_PROGRAMMERS, CRED_WATANABE, CRED_MASUDE, CRED_TAMADA, CRED_TEXT_MON
	.DB CRED_CHAR_DESIGN, CRED_SUGIMORI, CRED_NISHIDA, CRED_TEXT_FADE_MON
	.DB CRED_MUSIC, CRED_MASUDE, CRED_TEXT_FADE
	.DB CRED_SOUND_EFFECTS, CRED_MASUDE, CRED_TEXT_MON
	.DB CRED_GAME_DESIGN, CRED_TAJIRI, CRED_TEXT_FADE_MON
	.DB CRED_MONSTER_DESIGN, CRED_SUGIMORI, CRED_NISHIDA, CRED_FUZIWARA, CRED_TEXT_FADE
	.DB CRED_MONSTER_DESIGN, CRED_MORIMOTO, CRED_SA_OOTA, CRED_YOSHIKAWA, CRED_TEXT_MON
	.DB CRED_GAME_SCENE, CRED_TAJIRI, CRED_TEXT_FADE
	.DB CRED_GAME_SCENE, CRED_TANIGUCHI, CRED_NONOMURA, CRED_ZINNAI, CRED_TEXT_MON
	.DB CRED_PARAM, CRED_NISINO, CRED_TA_NAKAMURA, CRED_TEXT_FADE_MON
	.DB CRED_MAP, CRED_TAJIRI, CRED_NISINO, CRED_TEXT_FADE
	.DB CRED_MAP, CRED_MATSUSIMA, CRED_NONOMURA, CRED_TANIGUCHI, CRED_TEXT_MON
	.DB CRED_TEST, CRED_KAKEI, CRED_TSUCHIYA, CRED_TEXT_FADE
	.DB CRED_TEST, CRED_TA_NAKAMURA, CRED_YUDA, CRED_TEXT_MON
	.DB CRED_SPECIAL, CRED_HISHIDA, CRED_SAKAI, CRED_TEXT_FADE
	.DB CRED_SPECIAL, CRED_YAMAGUCHI, CRED_YAMAMOTO, CRED_TEXT
	.DB CRED_SPECIAL, CRED_TOMISAWA, CRED_KAWAMOTO, CRED_TO_OOTA, CRED_TEXT_MON
	.DB CRED_PRODUCERS, CRED_MIYAMOTO, CRED_TEXT_FADE
	.DB CRED_PRODUCERS, CRED_KAWAGUCHI, CRED_TEXT
	.DB CRED_PRODUCERS, CRED_ISHIHARA, CRED_TEXT_MON
	.DB CRED_US_STAFF, CRED_TEXT_FADE
	.DB CRED_US_COORD, CRED_TILDEN, CRED_TEXT_FADE
	.DB CRED_US_COORD, CRED_KAWAKAMI, CRED_HI_NAKAMURA, CRED_TEXT
	.DB CRED_US_COORD, CRED_GIESE, CRED_OSBORNE, CRED_TEXT
	.DB CRED_TRANS, CRED_OGASAWARA, CRED_TEXT_FADE
	.DB CRED_PROGRAMMERS, CRED_MURAKAWA, CRED_FUKUI, CRED_TEXT_FADE
	.DB CRED_SPECIAL, CRED_IWATA, CRED_TEXT_FADE
	.DB CRED_SPECIAL, CRED_HARADA, CRED_TEXT
	.DB CRED_TEST, CRED_PAAD, CRED_CLUB, CRED_TEXT_FADE
	.DB CRED_PRODUCER, CRED_IZUSHI, CRED_TEXT_FADE
	.DB CRED_EXECUTIVE, CRED_YAMAUCHI, CRED_TEXT_FADE_MON
	.DB CRED_COPYRIGHT, CRED_TEXT_FADE_MON
	.DB CRED_THE_END

CreditsTextPointers:
; entries correspond to CRED_* constants
; table_width 2
	.DW CredVersion
	.DW CredTajiri
	.DW CredTaOota
	.DW CredMorimoto
	.DW CredWatanabe
	.DW CredMasuda
	.DW CredNisino
	.DW CredSugimori
	.DW CredNishida
	.DW CredMiyamoto
	.DW CredKawaguchi
	.DW CredIshihara
	.DW CredYamauchi
	.DW CredZinnai
	.DW CredHishida
	.DW CredSakai
	.DW CredYamaguchi
	.DW CredYamamoto
	.DW CredTaniguchi
	.DW CredNonomura
	.DW CredFuziwara
	.DW CredMatsusima
	.DW CredTomisawa
	.DW CredKawamoto
	.DW CredKakei
	.DW CredTsuchiya
	.DW CredTaNakamura
	.DW CredYuda
	.DW CredMon
	.DW CredDirector
	.DW CredProgrammers
	.DW CredCharDesign
	.DW CredMusic
	.DW CredSoundEffects
	.DW CredGameDesign
	.DW CredMonsterDesign
	.DW CredGameScene
	.DW CredParam
	.DW CredMap
	.DW CredTest
	.DW CredSpecial
	.DW CredProducers
	.DW CredProducer
	.DW CredExecutive
	.DW CredTamada
	.DW CredSaOota
	.DW CredYoshikawa
	.DW CredToOota
	.DW CredUSStaff
	.DW CredUSCoord
	.DW CredTilden
	.DW CredKawakami
	.DW CredHiNakamura
	.DW CredGiese
	.DW CredOsborne
	.DW CredTrans
	.DW CredOgasawara
	.DW CredIwata
	.DW CredIzushi
	.DW CredHarada
	.DW CredMurakawa
	.DW CredFukui
	.DW CredClub
	.DW CredPAAD
; assert_table_length NUM_CRED_STRINGS

CredVersion:
	.DB -8, $91, $84, $83, $7f, $95, $84, $91, $92, $88, $8e, $8d, $7f, $92, $93, $80, $85, $85, $50
CredTajiri:
	.DB -6, $92, $80, $93, $8e, $92, $87, $88, $7f, $93, $80, $89, $88, $91, $88, $50
CredTaOota:
	.DB -6, $93, $80, $8a, $84, $8d, $8e, $91, $88, $7f, $8e, $8e, $93, $80, $50
CredMorimoto:
	.DB -7, $92, $87, $88, $86, $84, $8a, $88, $7f, $8c, $8e, $91, $88, $8c, $8e, $93, $8e, $50
CredWatanabe:
	.DB -7, $93, $84, $93, $92, $94, $98, $80, $7f, $96, $80, $93, $80, $8d, $80, $81, $84, $50
CredMasuda:
	.DB -6, $89, $94, $8d, $88, $82, $87, $88, $7f, $8c, $80, $92, $94, $83, $80, $50
CredNisino:
	.DB -5, $8a, $8e, $87, $89, $88, $7f, $8d, $88, $92, $88, $8d, $8e, $50
CredSugimori:
	.DB -5, $8a, $84, $8d, $7f, $92, $94, $86, $88, $8c, $8e, $91, $88, $50
CredNishida:
	.DB -6, $80, $93, $92, $94, $8a, $8e, $7f, $8d, $88, $92, $87, $88, $83, $80, $50
CredMiyamoto:
	.DB -7, $92, $87, $88, $86, $84, $91, $94, $7f, $8c, $88, $98, $80, $8c, $8e, $93, $8e, $50
CredKawaguchi:
	.DB -8, $93, $80, $8a, $80, $92, $87, $88, $7f, $8a, $80, $96, $80, $86, $94, $82, $87, $88, $50
CredIshihara:
	.DB -8, $93, $92, $94, $8d, $84, $8a, $80, $99, $94, $7f, $88, $92, $87, $88, $87, $80, $91, $80, $50
CredYamauchi:
	.DB -7, $87, $88, $91, $8e, $92, $87, $88, $7f, $98, $80, $8c, $80, $94, $82, $87, $88, $50
CredZinnai:
	.DB -7, $87, $88, $91, $8e, $98, $94, $8a, $88, $7f, $99, $88, $8d, $8d, $80, $88, $50
CredHishida:
	.DB -7, $93, $80, $93, $92, $94, $98, $80, $7f, $87, $88, $92, $87, $88, $83, $80, $50
CredSakai:
	.DB -6, $98, $80, $92, $94, $87, $88, $91, $8e, $7f, $92, $80, $8a, $80, $88, $50
CredYamaguchi:
	.DB -7, $96, $80, $93, $80, $91, $94, $7f, $98, $80, $8c, $80, $86, $94, $82, $87, $88, $50
CredYamamoto:
	.DB -8, $8a, $80, $99, $94, $98, $94, $8a, $88, $7f, $98, $80, $8c, $80, $8c, $8e, $93, $8e, $50
CredTaniguchi:
	.DB -8, $91, $98, $8e, $87, $92, $94, $8a, $84, $7f, $93, $80, $8d, $88, $86, $94, $82, $87, $88, $50
CredNonomura:
	.DB -8, $85, $94, $8c, $88, $87, $88, $91, $8e, $7f, $8d, $8e, $8d, $8e, $8c, $94, $91, $80, $50
CredFuziwara:
	.DB -7, $8c, $8e, $93, $8e, $85, $94, $8c, $88, $7f, $85, $94, $99, $88, $96, $80, $91, $80, $50
CredMatsusima:
	.DB -7, $8a, $84, $8d, $89, $88, $7f, $8c, $80, $93, $92, $94, $92, $88, $8c, $80, $50
CredTomisawa:
	.DB -7, $80, $8a, $88, $87, $88, $93, $8e, $7f, $93, $8e, $8c, $88, $92, $80, $96, $80, $50
CredKawamoto:
	.DB -7, $87, $88, $91, $8e, $92, $87, $88, $7f, $8a, $80, $96, $80, $8c, $8e, $93, $8e, $50
CredKakei:
	.DB -6, $80, $8a, $88, $98, $8e, $92, $87, $88, $7f, $8a, $80, $8a, $84, $88, $50
CredTsuchiya:
	.DB -7, $8a, $80, $99, $94, $8a, $88, $7f, $93, $92, $94, $82, $87, $88, $98, $80, $50
CredTaNakamura:
	.DB -6, $93, $80, $8a, $84, $8e, $7f, $8d, $80, $8a, $80, $8c, $94, $91, $80, $50
CredYuda:
	.DB -6, $8c, $80, $92, $80, $8c, $88, $93, $92, $94, $7f, $98, $94, $83, $80, $50
CredMon:
	.DB -3, $54, $8c, $8e, $8d, $50
CredDirector:
	.DB -3, $83, $88, $91, $84, $82, $93, $8e, $91, $50
CredProgrammers:
	.DB -5, $8f, $91, $8e, $86, $91, $80, $8c, $8c, $84, $91, $92, $50
CredCharDesign:
	.DB -7, $82, $87, $80, $91, $80, $82, $93, $84, $91, $7f, $83, $84, $92, $88, $86, $8d, $50
CredMusic:
	.DB -2, $8c, $94, $92, $88, $82, $50
CredSoundEffects:
	.DB -6, $92, $8e, $94, $8d, $83, $7f, $84, $85, $85, $84, $82, $93, $92, $50
CredGameDesign:
	.DB -5, $86, $80, $8c, $84, $7f, $83, $84, $92, $88, $86, $8d, $50
CredMonsterDesign:
	.DB -6, $8c, $8e, $8d, $92, $93, $84, $91, $7f, $83, $84, $92, $88, $86, $8d, $50
CredGameScene:
	.DB -6, $86, $80, $8c, $84, $7f, $92, $82, $84, $8d, $80, $91, $88, $8e, $50
CredParam:
	.DB -8, $8f, $80, $91, $80, $8c, $84, $93, $91, $88, $82, $7f, $83, $84, $92, $88, $86, $8d, $50
CredMap:
	.DB -4, $8c, $80, $8f, $7f, $83, $84, $92, $88, $86, $8d, $50
CredTest:
	.DB -7, $8f, $91, $8e, $83, $94, $82, $93, $7f, $93, $84, $92, $93, $88, $8d, $86, $50
CredSpecial:
	.DB -6, $92, $8f, $84, $82, $88, $80, $8b, $7f, $93, $87, $80, $8d, $8a, $92, $50
CredProducers:
	.DB -4, $8f, $91, $8e, $83, $94, $82, $84, $91, $92, $50
CredProducer:
	.DB -4, $8f, $91, $8e, $83, $94, $82, $84, $91, $50
CredExecutive:
	.DB -8, $84, $97, $84, $82, $94, $93, $88, $95, $84, $7f, $8f, $91, $8e, $83, $94, $82, $84, $91, $50
CredTamada:
	.DB -6, $92, $8e, $94, $92, $94, $8a, $84, $7f, $93, $80, $8c, $80, $83, $80, $50
CredSaOota:
	.DB -5, $92, $80, $93, $8e, $92, $87, $88, $7f, $8e, $8e, $93, $80, $50
CredYoshikawa:
	.DB -6, $91, $84, $8d, $80, $7f, $98, $8e, $92, $87, $88, $8a, $80, $96, $80, $50
CredToOota:
	.DB -6, $93, $8e, $8c, $8e, $8c, $88, $82, $87, $88, $7f, $8e, $8e, $93, $80, $50
CredUSStaff:
	.DB -7, $94, $92, $7f, $95, $84, $91, $92, $88, $8e, $8d, $7f, $92, $93, $80, $85, $85, $50
CredUSCoord:
	.DB -7, $94, $92, $7f, $82, $8e, $8e, $91, $83, $88, $8d, $80, $93, $88, $8e, $8d, $50
CredTilden:
	.DB -5, $86, $80, $88, $8b, $7f, $93, $88, $8b, $83, $84, $8d, $50
CredKawakami:
	.DB -6, $8d, $80, $8e, $8a, $8e, $7f, $8a, $80, $96, $80, $8a, $80, $8c, $88, $50
CredHiNakamura:
	.DB -6, $87, $88, $91, $8e, $7f, $8d, $80, $8a, $80, $8c, $94, $91, $80, $50
CredGiese:
	.DB -6, $96, $88, $8b, $8b, $88, $80, $8c, $7f, $86, $88, $84, $92, $84, $50
CredOsborne:
	.DB -5, $92, $80, $91, $80, $7f, $8e, $92, $81, $8e, $91, $8d, $84, $50
CredTrans:
	.DB -7, $93, $84, $97, $93, $7f, $93, $91, $80, $8d, $92, $8b, $80, $93, $88, $8e, $8d, $50
CredOgasawara:
	.DB -6, $8d, $8e, $81, $7f, $8e, $86, $80, $92, $80, $96, $80, $91, $80, $50
CredIwata:
	.DB -5, $92, $80, $93, $8e, $91, $94, $7f, $88, $96, $80, $93, $80, $50
CredIzushi:
	.DB -7, $93, $80, $8a, $84, $87, $88, $91, $8e, $7f, $88, $99, $94, $92, $87, $88, $50
CredHarada:
	.DB -7, $93, $80, $8a, $80, $87, $88, $91, $8e, $7f, $87, $80, $91, $80, $83, $80, $50
CredMurakawa:
	.DB -7, $93, $84, $91, $94, $8a, $88, $7f, $8c, $94, $91, $80, $8a, $80, $96, $80, $50
CredFukui:
	.DB -5, $8a, $8e, $87, $93, $80, $7f, $85, $94, $8a, $94, $88, $50
CredClub:
	.DB -9, $8d, $82, $8b, $7f, $92, $94, $8f, $84, $91, $7f, $8c, $80, $91, $88, $8e, $7f, $82, $8b, $94, $81, $50
CredPAAD:
	.DB -5, $8f, $80, $80, $83, $7f, $93, $84, $92, $93, $88, $8d, $86, $50

TheEndGfx:
	.INCBIN "gfx/credits/the_end.2bpp"
TheEndGfxEnd:
PrintStatusAilment:
	ld a, (de)
	bit PSN, a
	jr nz, PrintStatusAilment.psn
	bit BRN, a
	jr nz, PrintStatusAilment.brn
	bit FRZ, a
	jr nz, PrintStatusAilment.frz
	bit PAR, a
	jr nz, PrintStatusAilment.par
	and SLP_MASK
	ret z
	ld a, $92
	ld (HL+), a
	ld a, $8b
	ld (HL+), a
	.DB $36, $8f
	ret
PrintStatusAilment.psn:
	ld a, $8f
	ld (HL+), a
	ld a, $92
	ld (HL+), a
	.DB $36, $8d
	ret
PrintStatusAilment.brn:
	ld a, $81
	ld (HL+), a
	ld a, $91
	ld (HL+), a
	.DB $36, $8d
	ret
PrintStatusAilment.frz:
	ld a, $85
	ld (HL+), a
	ld a, $91
	ld (HL+), a
	.DB $36, $99
	ret
PrintStatusAilment.par:
	ld a, $8f
	ld (HL+), a
	ld a, $80
	ld (HL+), a
	.DB $36, $91
	ret
HiddenItemNear:
	ld hl, HiddenItemCoords
	ld b, 0
HiddenItemNear.loop:
	ld de, 3
	ld a, (wCurMap)
	call IsInRestOfArray
	ret nc ; return if current map has no hidden items
	push bc
	push hl
	ld hl, wObtainedHiddenItemsFlags
	ld c, b
	ld b, FLAG_TEST
	ld a, $10
	call Predef
	ld a, c
	pop hl
	pop bc
	inc b
	and a
	inc hl
	ld d, (hl)
	inc hl
	ld e, (hl)
	inc hl
	jr nz, HiddenItemNear.loop ; if the item has already been obtained
; check if the item is within 4-5 tiles (depending on the direction of item)
	ld a, (wYCoord)
	call Sub5ClampTo0
	cp d
	jr nc, HiddenItemNear.loop
	ld a, (wYCoord)
	add 4
	cp d
	jr c, HiddenItemNear.loop
	ld a, (wXCoord)
	call Sub5ClampTo0
	cp e
	jr nc, HiddenItemNear.loop
	ld a, (wXCoord)
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
Itemfinder1End:
