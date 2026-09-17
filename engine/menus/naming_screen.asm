AskName:
	call SaveScreenTilesToBuffer1
	call GetPredefRegisters
	push hl
	ld a, [wIsInBattle]
	dec a
	hlcoord 0, 0
	ld b, 4
	ld c, 11
	call z, ClearScreenArea ; only if in wild battle
	ld a, [wCurPartySpecies]
	ld [wNamedObjectIndex], a
	call GetMonName
	ld hl, DoYouWantToNicknameText
	call PrintText
	hlcoord 14, 7
	lb "bc", 8, 15
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	pop hl
	ld a, [wCurrentMenuItem]
	and a
	jr nz, AskName.declinedNickname
	ld a, [wUpdateSpritesEnabled]
	push af
	xor a
	ld [wUpdateSpritesEnabled], a
	push hl
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	call DisplayNamingScreen
	ld a, [wIsInBattle]
	and a
	jr nz, AskName.inBattle
	call ReloadMapSpriteTilePatterns
AskName.inBattle
	call LoadScreenTilesFromBuffer1
	pop hl
	pop af
	ld [wUpdateSpritesEnabled], a
	ld a, [wStringBuffer]
	cp $50
	ret nz
AskName.declinedNickname
	ld d, h
	ld e, l
	ld hl, wNameBuffer
	ld bc, NAME_LENGTH
	jp CopyData

DoYouWantToNicknameText:
	text_far WLA_GLOBAL_DoYouWantToNicknameText
	text_end

DisplayNameRaterScreen:
	ld hl, wBuffer
	xor a
	ld [wUpdateSpritesEnabled], a
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	call DisplayNamingScreen
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	ld a, [wStringBuffer]
	cp $50
	jr z, DisplayNameRaterScreen.playerCancelled
	ld hl, wPartyMonNicks
	ld bc, NAME_LENGTH
	ld a, [wWhichPokemon]
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, wBuffer
	ld bc, NAME_LENGTH
	call CopyData
	and a
	ret
DisplayNameRaterScreen.playerCancelled
	scf
	ret

DisplayNamingScreen:
	push hl
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	call LoadHpBarAndStatusTilePatterns
	call LoadEDTile
	farcall LoadMonPartySpriteGfx
	hlcoord 0, 4
	ld b, 9
	ld c, 18
	call TextBoxBorder
	call PrintNamingText
	ld a, 3
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	ld [wLastMenuItem], a
	ld [wCurrentMenuItem], a
	ld a, $ff
	ld [wMenuWatchedKeys], a
	ld a, 7
	ld [wMaxMenuItem], a
	ld a, $50
	ld [wStringBuffer], a
	xor a
	ld hl, wNamingScreenSubmitName
	ld [hli], a
	ld [hli], a
	ld [wAnimCounter], a
DisplayNamingScreen.selectReturnPoint
	call PrintAlphabet
	call GBPalNormal
DisplayNamingScreen.ABStartReturnPoint
	ld a, [wNamingScreenSubmitName]
	and a
	jr nz, DisplayNamingScreen.submitNickname
	call PrintNicknameAndUnderscores
DisplayNamingScreen.dPadReturnPoint
	call PlaceMenuCursor
DisplayNamingScreen.inputLoop
	ld a, [wCurrentMenuItem]
	push af
	farcall AnimatePartyMon_ForceSpeed1
	pop af
	ld [wCurrentMenuItem], a
	call JoypadLowSensitivity
	ldh a, [lobyte(hJoyPressed)]
	and a
	jr z, DisplayNamingScreen.inputLoop
	ld hl, DisplayNamingScreen.namingScreenButtonFunctions
DisplayNamingScreen.checkForPressedButton
	sla a
	jr c, DisplayNamingScreen.foundPressedButton
	inc hl
	inc hl
	inc hl
	inc hl
	jr DisplayNamingScreen.checkForPressedButton
DisplayNamingScreen.foundPressedButton
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	jp hl

DisplayNamingScreen.submitNickname
	pop de
	ld hl, wStringBuffer
	ld bc, NAME_LENGTH
	call CopyData
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call ClearSprites
	call RunDefaultPaletteCommand
	call GBPalNormal
	xor a
	ld [wAnimCounter], a
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ld a, [wIsInBattle]
	and a
	jp z, LoadTextBoxTilePatterns
	jpfar LoadHudTilePatterns

DisplayNamingScreen.namingScreenButtonFunctions
	.DW DisplayNamingScreen.dPadReturnPoint
	.DW DisplayNamingScreen.pressedDown
	.DW DisplayNamingScreen.dPadReturnPoint
	.DW DisplayNamingScreen.pressedUp
	.DW DisplayNamingScreen.dPadReturnPoint
	.DW DisplayNamingScreen.pressedLeft
	.DW DisplayNamingScreen.dPadReturnPoint
	.DW DisplayNamingScreen.pressedRight
	.DW DisplayNamingScreen.ABStartReturnPoint
	.DW DisplayNamingScreen.pressedStart
	.DW DisplayNamingScreen.selectReturnPoint
	.DW DisplayNamingScreen.pressedSelect
	.DW DisplayNamingScreen.ABStartReturnPoint
	.DW DisplayNamingScreen.pressedB
	.DW DisplayNamingScreen.ABStartReturnPoint
	.DW DisplayNamingScreen.pressedA

DisplayNamingScreen.pressedA_changedCase
	pop de
	ld de, DisplayNamingScreen.selectReturnPoint
	push de
DisplayNamingScreen.pressedSelect
	ld a, [wAlphabetCase]
	xor $1
	ld [wAlphabetCase], a
	ret

DisplayNamingScreen.pressedStart
	ld a, 1
	ld [wNamingScreenSubmitName], a
	ret

DisplayNamingScreen.pressedA
	ld a, [wCurrentMenuItem]
	cp $5 ; "ED" row
	jr nz, DisplayNamingScreen.didNotPressED
	ld a, [wTopMenuItemX]
	cp $11 ; "ED" column
	jr z, DisplayNamingScreen.pressedStart
DisplayNamingScreen.didNotPressED
	ld a, [wCurrentMenuItem]
	cp $6 ; case switch row
	jr nz, DisplayNamingScreen.didNotPressCaseSwitch
	ld a, [wTopMenuItemX]
	cp $1 ; case switch column
	jr z, DisplayNamingScreen.pressedA_changedCase
DisplayNamingScreen.didNotPressCaseSwitch
	ld hl, wMenuCursorLocation
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	ld a, [hl]
	ld [wNamingScreenLetter], a
	call CalcStringLength
	ld a, [wNamingScreenLetter]
	cp $e5
	ld de, Dakutens
	jr z, DisplayNamingScreen.dakutensAndHandakutens
	cp $e4
	ld de, Handakutens
	jr z, DisplayNamingScreen.dakutensAndHandakutens
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	jr nc, DisplayNamingScreen.checkMonNameLength
	ld a, [wNamingScreenNameLength]
	cp PLAYER_NAME_LENGTH - 1
	jr DisplayNamingScreen.checkNameLength
DisplayNamingScreen.checkMonNameLength
	ld a, [wNamingScreenNameLength]
	cp NAME_LENGTH - 1
DisplayNamingScreen.checkNameLength
	jr c, DisplayNamingScreen.addLetter
	ret

DisplayNamingScreen.dakutensAndHandakutens
	push hl
	call DakutensAndHandakutens
	pop hl
	ret nc
	dec hl
DisplayNamingScreen.addLetter
	ld a, [wNamingScreenLetter]
	ld [hli], a
	ld [hl], $50
	ld a, SFX_PRESS_AB
	call PlaySound
	ret
DisplayNamingScreen.pressedB
	ld a, [wNamingScreenNameLength]
	and a
	ret z
	call CalcStringLength
	dec hl
	ld [hl], $50
	ret
DisplayNamingScreen.pressedRight
	ld a, [wCurrentMenuItem]
	cp $6
	ret z ; can't scroll right on bottom row
	ld a, [wTopMenuItemX]
	cp $11 ; max
	jp z, DisplayNamingScreen.wrapToFirstColumn
	inc a
	inc a
	jr DisplayNamingScreen.done
DisplayNamingScreen.wrapToFirstColumn
	ld a, $1
	jr DisplayNamingScreen.done
DisplayNamingScreen.pressedLeft
	ld a, [wCurrentMenuItem]
	cp $6
	ret z ; can't scroll right on bottom row
	ld a, [wTopMenuItemX]
	dec a
	jp z, DisplayNamingScreen.wrapToLastColumn
	dec a
	jr DisplayNamingScreen.done
DisplayNamingScreen.wrapToLastColumn
	ld a, $11 ; max
	jr DisplayNamingScreen.done
DisplayNamingScreen.pressedUp
	ld a, [wCurrentMenuItem]
	dec a
	ld [wCurrentMenuItem], a
	and a
	ret nz
	ld a, $6 ; wrap to bottom row
	ld [wCurrentMenuItem], a
	ld a, $1 ; force left column
	jr DisplayNamingScreen.done
DisplayNamingScreen.pressedDown
	ld a, [wCurrentMenuItem]
	inc a
	ld [wCurrentMenuItem], a
	cp $7
	jr nz, DisplayNamingScreen.wrapToTopRow
	ld a, $1
	ld [wCurrentMenuItem], a
	jr DisplayNamingScreen.done
DisplayNamingScreen.wrapToTopRow
	cp $6
	ret nz
	ld a, $1
DisplayNamingScreen.done
	ld [wTopMenuItemX], a
	jp EraseMenuCursor

LoadEDTile:
	ld de, ED_Tile
	ld hl, vFont + TILE_SIZE * $70
	; BUG: bank("Home") should be bank(ED_Tile), although it coincidentally works as-is
	lb "bc", 0, (ED_TileEnd - ED_Tile) / TILE_1BPP_SIZE
	jp CopyVideoDataDouble

ED_Tile:
	.INCBIN "gfx/font/ED.1bpp"
ED_TileEnd:

PrintAlphabet:
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld a, [wAlphabetCase]
	and a
	ld de, LowerCaseAlphabet
	jr nz, PrintAlphabet.lowercase
	ld de, UpperCaseAlphabet
PrintAlphabet.lowercase
	hlcoord 2, 5
	lb "bc", 5, 9 ; 5 rows, 9 columns
PrintAlphabet.outerLoop
	push bc
PrintAlphabet.innerLoop
	ld a, [de]
	ld [hli], a
	inc hl
	inc de
	dec c
	jr nz, PrintAlphabet.innerLoop
	ld bc, SCREEN_WIDTH + 2
	add hl, bc
	pop bc
	dec b
	jr nz, PrintAlphabet.outerLoop
	call PlaceString
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	jp Delay3

.INCLUDE "data/text/alphabets.asm"

PrintNicknameAndUnderscores:
	call CalcStringLength
	ld a, c
	ld [wNamingScreenNameLength], a
	hlcoord 10, 2
	lb "bc", 1, 10
	call ClearScreenArea
	hlcoord 10, 2
	ld de, wStringBuffer
	call PlaceString
	hlcoord 10, 3
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	jr nc, PrintNicknameAndUnderscores.pokemon
; player or rival
	ld b, PLAYER_NAME_LENGTH - 1
	jr PrintNicknameAndUnderscores.gotUnderscoreCount
PrintNicknameAndUnderscores.pokemon
	ld b, NAME_LENGTH - 1
PrintNicknameAndUnderscores.gotUnderscoreCount
	ld a, $76 ; underscore tile id
PrintNicknameAndUnderscores.placeUnderscoreLoop
	ld [hli], a
	dec b
	jr nz, PrintNicknameAndUnderscores.placeUnderscoreLoop
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	ld a, [wNamingScreenNameLength]
	jr nc, PrintNicknameAndUnderscores.pokemon2
; player or rival
	cp PLAYER_NAME_LENGTH - 1
	jr PrintNicknameAndUnderscores.checkEmptySpaces
PrintNicknameAndUnderscores.pokemon2
	cp NAME_LENGTH - 1
PrintNicknameAndUnderscores.checkEmptySpaces
	jr nz, PrintNicknameAndUnderscores.placeRaisedUnderscore ; jump if empty spaces remain
	; when all spaces are filled, force the cursor onto the ED tile,
	; and keep the last underscore raised
	call EraseMenuCursor
	ld a, $11 ; "ED" x coord
	ld [wTopMenuItemX], a
	ld a, $5 ; "ED" y coord
	ld [wCurrentMenuItem], a
	ld a, [wNamingScreenType]
	cp NAME_MON_SCREEN
	ld a, NAME_LENGTH - 2
	jr nc, PrintNicknameAndUnderscores.placeRaisedUnderscore
	ld a, PLAYER_NAME_LENGTH - 2
PrintNicknameAndUnderscores.placeRaisedUnderscore
	ld c, a
	ld b, $0
	hlcoord 10, 3
	add hl, bc
	ld [hl], $77 ; raised underscore tile id
	ret

DakutensAndHandakutens:
	push de
	call CalcStringLength
	dec hl
	ld a, [hl]
	pop hl
	ld de, $2
	call IsInArray
	ret nc
	inc hl
	ld a, [hl]
	ld [wNamingScreenLetter], a
	ret

.INCLUDE "data/text/dakutens.asm"

; calculates the length of the string at wStringBuffer and stores it in c
CalcStringLength:
	ld hl, wStringBuffer
	ld c, $0
CalcStringLength.loop
	ld a, [hl]
	cp $50
	ret z
	inc hl
	inc c
	jr CalcStringLength.loop

PrintNamingText:
	hlcoord 0, 1
	ld a, [wNamingScreenType]
	ld de, YourTextString
	and a
	jr z, PrintNamingText.notNickname
	ld de, RivalsTextString
	dec a
	jr z, PrintNamingText.notNickname
	ld a, [wCurPartySpecies]
	ld [wMonPartySpriteSpecies], a
	push af
	farcall WriteMonPartySpriteOAMBySpecies
	pop af
	ld [wNamedObjectIndex], a
	call GetMonName
	hlcoord 4, 1
	call PlaceString
	ld hl, $1
	add hl, bc
	ld [hl], $c9 ; leftover from Japanese version; blank tile $c9 in English
	hlcoord 1, 3
	ld de, NicknameTextString
	jr PrintNamingText.placeString
PrintNamingText.notNickname
	call PlaceString
	ld l, c
	ld h, b
	ld de, NameTextString
PrintNamingText.placeString
	jp PlaceString

YourTextString:
		.STRINGMAP pokemon, "YOUR @"

RivalsTextString:
		.STRINGMAP pokemon, "RIVAL's @"

NameTextString:
		.STRINGMAP pokemon, "NAME?@"

NicknameTextString:
		.STRINGMAP pokemon, "NICKNAME?@"
