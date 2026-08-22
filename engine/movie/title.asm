CopyDebugName:
	ld bc, NAME_LENGTH
	jp CopyData

PrepareTitleScreen:
	; These debug names are already copied later in PrepareOakSpeech.
	; Removing the unused copies below has no apparent impact.
	; CopyDebugName can also be safely deleted afterwards.
	ld hl, DebugNewGamePlayerName
	ld de, wPlayerName
	call CopyDebugName
	ld hl, DebugNewGameRivalName
	ld de, wRivalName
	call CopyDebugName
	xor a
	ldh [lobyte(hWY)], a
	ld [wLetterPrintingDelayFlags], a
	ld hl, wStatusFlags6
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, bank(Music_TitleScreen)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a

DisplayTitleScreen:
	call GBPalWhiteOut
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	xor a
	ldh [lobyte(hTileAnimations)], a
	ldh [lobyte(hSCX)], a
	ld a, $40
	ldh [lobyte(hSCY)], a
	ld a, $90
	ldh [lobyte(hWY)], a
	call ClearScreen
	call DisableLCD
	call LoadFontTilePatterns
	ld hl, NintendoCopyrightLogoGraphics
	ld de, vTitleLogo2 + TILE_SIZE * 16
	ld bc, 5 * TILE_SIZE
	ld a, bank(NintendoCopyrightLogoGraphics)
	call FarCopyData2
	ld hl, GameFreakLogoGraphics
	ld de, vTitleLogo2 + TILE_SIZE * (16 + 5)
	ld bc, 9 * TILE_SIZE
	ld a, bank(GameFreakLogoGraphics)
	call FarCopyData2
	ld hl, PokemonLogoGraphics
	ld de, vTitleLogo
	ld bc, $60 * TILE_SIZE
	ld a, bank(PokemonLogoGraphics)
	call FarCopyData2          ; first chunk
	ld hl, PokemonLogoGraphics + TILE_SIZE * $60
	ld de, vTitleLogo2
	ld bc, $10 * TILE_SIZE
	ld a, bank(PokemonLogoGraphics)
	call FarCopyData2          ; second chunk
	ld hl, Version_GFX
	ld de, vChars2 + TILE_SIZE * $60 + (10 * TILE_SIZE - (Version_GFXEnd - Version_GFX) * 2) / 2
	ld bc, Version_GFXEnd - Version_GFX
	ld a, bank(Version_GFX)
	call FarCopyDataDouble
	call ClearBothBGMaps

; place tiles for pokemon logo (except for the last row)
	hlcoord 2, 1
	ld a, $80
	ld de, SCREEN_WIDTH
	ld c, 6
DisplayTitleScreen.pokemonLogoTileLoop
	ld b, $10
	push hl
DisplayTitleScreen.pokemonLogoTileRowLoop ; place tiles for one row
	ld [hli], a
	inc a
	dec b
	jr nz, DisplayTitleScreen.pokemonLogoTileRowLoop
	pop hl
	add hl, de
	dec c
	jr nz, DisplayTitleScreen.pokemonLogoTileLoop

; place tiles for the last row of the pokemon logo
	hlcoord 2, 7
	ld a, $31
	ld b, $10
DisplayTitleScreen.pokemonLogoLastTileRowLoop
	ld [hli], a
	inc a
	dec b
	jr nz, DisplayTitleScreen.pokemonLogoLastTileRowLoop

	call DrawPlayerCharacter

; put a pokeball in the player's hand
	ld hl, wShadowOAMSprite10
	ld a, $74
	ld [hl], a

; place tiles for title screen copyright
	hlcoord 2, 17
	ld de, DisplayTitleScreen.tileScreenCopyrightTiles
	ld b, DisplayTitleScreen.tileScreenCopyrightTilesEnd - DisplayTitleScreen.tileScreenCopyrightTiles
DisplayTitleScreen.tileScreenCopyrightTilesLoop
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, DisplayTitleScreen.tileScreenCopyrightTilesLoop

	jr DisplayTitleScreen.next

DisplayTitleScreen.tileScreenCopyrightTiles
	.DB $41,$42,$43,$42,$44,$42,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E ; ©'95.'96.'98 GAME FREAK inc.
DisplayTitleScreen.tileScreenCopyrightTilesEnd

DisplayTitleScreen.next
	call SaveScreenTilesToBuffer2
	call LoadScreenTilesFromBuffer2
	call EnableLCD

.IF defined(_RED)
	ld a, STARTER1 ; which Pokemon to show first on the title screen
.ENDIF
.IF defined(_BLUE)
	ld a, STARTER2 ; which Pokemon to show first on the title screen
.ENDIF
	ld [wTitleMonSpecies], a
	call LoadTitleMonSprite

	ld a, hibyte(vBGMap0 + $300)
	call TitleScreenCopyTileMapToVRAM
	call SaveScreenTilesToBuffer1
	ld a, $40
	ldh [lobyte(hWY)], a
	call LoadScreenTilesFromBuffer2
	ld a, hibyte(vBGMap0)
	call TitleScreenCopyTileMapToVRAM
	ld b, SET_PAL_TITLE_SCREEN
	call RunPaletteCommand
	call GBPalNormal
	ld a, %11100100
	ldh [lobyte(rOBP0)], a

; make pokemon logo bounce up and down
	ld bc, hSCY ; background scroll Y
	ld hl, DisplayTitleScreen.TitleScreenPokemonLogoYScrolls
DisplayTitleScreen.bouncePokemonLogoLoop
	ld a, [hli]
	and a
	jr z, DisplayTitleScreen.finishedBouncingPokemonLogo
	ld d, a
	cp -3
	jr nz, DisplayTitleScreen.skipPlayingSound
	ld a, SFX_INTRO_CRASH
	call PlaySound
DisplayTitleScreen.skipPlayingSound
	ld a, [hli]
	ld e, a
	call DisplayTitleScreen.ScrollTitleScreenPokemonLogo
	jr DisplayTitleScreen.bouncePokemonLogoLoop

DisplayTitleScreen.TitleScreenPokemonLogoYScrolls:
; Controls the bouncing effect of the Pokemon logo on the title screen
	.DB -4,16  ; y scroll amount, number of times to scroll
	.DB 3,4
	.DB -3,4
	.DB 2,2
	.DB -2,2
	.DB 1,2
	.DB -1,2
	.DB 0      ; terminate list with 0

DisplayTitleScreen.ScrollTitleScreenPokemonLogo:
; Scrolls the Pokemon logo on the title screen to create the bouncing effect
; Scrolls d pixels e times
	call DelayFrame
	ld a, [bc] ; background scroll Y
	add d
	ld [bc], a
	dec e
	jr nz, DisplayTitleScreen.ScrollTitleScreenPokemonLogo
	ret

DisplayTitleScreen.finishedBouncingPokemonLogo
	call LoadScreenTilesFromBuffer1
	ld c, 36
	call DelayFrames
	ld a, SFX_INTRO_WHOOSH
	call PlaySound

; scroll game version in from the right
	call PrintGameVersionOnTitleScreen
	ld a, SCREEN_HEIGHT_PX
	ldh [lobyte(hWY)], a
	ld d, 144
DisplayTitleScreen.scrollTitleScreenGameVersionLoop
	ld h, d
	ld l, 64
	call ScrollTitleScreenGameVersion
	ld h, 0
	ld l, 80
	call ScrollTitleScreenGameVersion
	ld a, d
	add 4
	ld d, a
	and a
	jr nz, DisplayTitleScreen.scrollTitleScreenGameVersionLoop

	ld a, hibyte(vBGMap1)
	call TitleScreenCopyTileMapToVRAM
	call LoadScreenTilesFromBuffer2
	call PrintGameVersionOnTitleScreen
	call Delay3
	call WaitForSoundToFinish
	ld a, MUSIC_TITLE_SCREEN
	ld [wNewSoundID], a
	call PlaySound
	xor a
	ld [wUnusedFlag], a

; Keep scrolling in new mons indefinitely until the user performs input.
DisplayTitleScreen.awaitUserInterruptionLoop
	ld c, 200
	call CheckForUserInterruption
	jr c, DisplayTitleScreen.finishedWaiting
	call TitleScreenScrollInMon
	ld c, 1
	call CheckForUserInterruption
	jr c, DisplayTitleScreen.finishedWaiting
	farcall TitleScreenAnimateBallIfStarterOut
	call TitleScreenPickNewMon
	jr DisplayTitleScreen.awaitUserInterruptionLoop

DisplayTitleScreen.finishedWaiting
	ld a, [wTitleMonSpecies]
	call PlayCry
	call WaitForSoundToFinish
	call GBPalWhiteOutWithDelay3
	call ClearSprites
	xor a
	ldh [lobyte(hWY)], a
	inc a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call ClearScreen
	ld a, hibyte(vBGMap0)
	call TitleScreenCopyTileMapToVRAM
	ld a, hibyte(vBGMap1)
	call TitleScreenCopyTileMapToVRAM
	call Delay3
	call LoadGBPal
	ldh a, [lobyte(hJoyHeld)]
	ld b, a
	and PAD_UP | PAD_SELECT | PAD_B
	cp PAD_UP | PAD_SELECT | PAD_B
	jp z, DisplayTitleScreen.doClearSaveDialogue
.IF defined(_DEBUG)
	ld a, b
	bit B_PAD_SELECT, a
	jp nz, DebugMenu
.ENDIF
	jp MainMenu

DisplayTitleScreen.doClearSaveDialogue
	farjp DoClearSaveDialogue

TitleScreenPickNewMon:
	ld a, hibyte(vBGMap0)
	call TitleScreenCopyTileMapToVRAM

TitleScreenPickNewMon.loop
; Keep looping until a mon different from the current one is picked.
	call Random
	and $f
	ld c, a
	ld b, 0
	ld hl, TitleMons
	add hl, bc
	ld a, [hl]
	ld hl, wTitleMonSpecies

; Can't be the same as before.
	cp [hl]
	jr z, TitleScreenPickNewMon.loop

	ld [hl], a
	call LoadTitleMonSprite

	ld a, $90
	ldh [lobyte(hWY)], a
	ld d, 1 ; scroll out
	farcall TitleScroll
	ret

TitleScreenScrollInMon:
	ld d, 0 ; scroll in
	farcall TitleScroll
	xor a
	ldh [lobyte(hWY)], a
	ret

ScrollTitleScreenGameVersion:
ScrollTitleScreenGameVersion.wait
	ldh a, [lobyte(rLY)]
	cp l
	jr nz, ScrollTitleScreenGameVersion.wait

	ld a, h
	ldh [lobyte(rSCX)], a

ScrollTitleScreenGameVersion.wait2
	ldh a, [lobyte(rLY)]
	cp h
	jr z, ScrollTitleScreenGameVersion.wait2
	ret

DrawPlayerCharacter:
	ld hl, PlayerCharacterTitleGraphics
	ld de, vSprites
	ld bc, PlayerCharacterTitleGraphicsEnd - PlayerCharacterTitleGraphics
	ld a, bank(PlayerCharacterTitleGraphics)
	call FarCopyData2
	call ClearSprites
	xor a
	ld [wPlayerCharacterOAMTile], a
	ld hl, wShadowOAM
	lb "de", $60, $5a
	ld b, 7
DrawPlayerCharacter.loop
	push de
	ld c, 5
DrawPlayerCharacter.innerLoop
	ld a, d
	ld [hli], a ; Y
	ld a, e
	ld [hli], a ; X
	add 8
	ld e, a
	ld a, [wPlayerCharacterOAMTile]
	ld [hli], a ; tile
	inc a
	ld [wPlayerCharacterOAMTile], a
	inc hl
	dec c
	jr nz, DrawPlayerCharacter.innerLoop
	pop de
	ld a, 8
	add d
	ld d, a
	dec b
	jr nz, DrawPlayerCharacter.loop
	ret

ClearBothBGMaps:
	ld hl, vBGMap0
	ld bc, 2 * TILEMAP_AREA
	ld a, $7f
	jp FillMemory

LoadTitleMonSprite:
	ld [wCurPartySpecies], a
	ld [wCurSpecies], a
	hlcoord 5, 10
	call GetMonHeader
	jp LoadFrontSpriteByMonIndex

TitleScreenCopyTileMapToVRAM:
	ldh [lobyte(hAutoBGTransferDest + 1)], a
	jp Delay3

LoadCopyrightAndTextBoxTiles:
	xor a
	ldh [lobyte(hWY)], a
	call ClearScreen
	call LoadTextBoxTilePatterns

LoadCopyrightTiles:
	ld de, NintendoCopyrightLogoGraphics
	ld hl, vChars2 + TILE_SIZE * $60
	lb "bc", bank(NintendoCopyrightLogoGraphics), (GameFreakLogoGraphicsEnd - NintendoCopyrightLogoGraphics) / TILE_SIZE
	call CopyVideoData
	hlcoord 2, 7
	ld de, CopyrightTextString
	jp PlaceString

CopyrightTextString:
	.DB   $60,$61,$62,$61,$63,$61,$64,$7F,$65,$66,$67,$68,$69,$6A             ; ©'95.'96.'98 Nintendo
	next $60,$61,$62,$61,$63,$61,$64,$7F,$6B,$6C,$6D,$6E,$6F,$70,$71,$72     ; ©'95.'96.'98 Creatures inc.
	next $60,$61,$62,$61,$63,$61,$64,$7F,$73,$74,$75,$76,$77,$78,$79,$7A,$7B ; ©'95.'96.'98 GAME FREAK inc.
		.STRINGMAP pokemon, "@"

.INCLUDE "data/pokemon/title_mons.asm"

; prints version text (red, blue)
PrintGameVersionOnTitleScreen:
	hlcoord 7, 8
	ld de, VersionOnTitleScreenText
	jp PlaceString

; these point to special tiles specifically loaded for that purpose and are not usual text
VersionOnTitleScreenText:
.IF defined(_RED)
		.DB $60, $61, $7F, $65, $66, $67, $68, $69
		.STRINGMAP pokemon, "@" ; "Red Version"
.ENDIF
.IF defined(_BLUE)
		.DB $61, $62, $63, $64, $65, $66, $67, $68
		.STRINGMAP pokemon, "@" ; "Blue Version"
.ENDIF

DebugNewGamePlayerName:
		.STRINGMAP pokemon, "NINTEN@"

DebugNewGameRivalName:
		.STRINGMAP pokemon, "SONY@"
