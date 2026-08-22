; function that displays the start menu
DrawStartMenu:
	CheckEvent EVENT_GOT_POKEDEX
; menu with pokedex
	hlcoord 10, 0
	ld b, $0e
	ld c, $08
	jr nz, DrawStartMenu.drawTextBoxBorder
; shorter menu if the player doesn't have the pokedex
	hlcoord 10, 0
	ld b, $0c
	ld c, $08
DrawStartMenu.drawTextBoxBorder
	call TextBoxBorder
	ld a, PAD_DOWN | PAD_UP | PAD_START | PAD_B | PAD_A
	ld [wMenuWatchedKeys], a
	ld a, $02
	ld [wTopMenuItemY], a ; Y position of first menu choice
	ld a, $0b
	ld [wTopMenuItemX], a ; X position of first menu choice
	ld a, [wBattleAndStartSavedMenuItem] ; remembered menu selection from last time
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 12, 2
	CheckEvent EVENT_GOT_POKEDEX
; case for not having pokedex
	ld a, $06
	jr z, DrawStartMenu.storeMenuItemCount
; case for having pokedex
	ld de, StartMenuPokedexText
	call PrintStartMenuItem
	ld a, $07
DrawStartMenu.storeMenuItemCount
	ld [wMaxMenuItem], a ; number of menu items
	ld de, StartMenuPokemonText
	call PrintStartMenuItem
	ld de, StartMenuItemText
	call PrintStartMenuItem
	ld de, wPlayerName ; player's name
	call PrintStartMenuItem
	ld a, [wStatusFlags4]
	bit BIT_LINK_CONNECTED, a
; case for not using link feature
	ld de, StartMenuSaveText
	jr z, DrawStartMenu.printSaveOrResetText
; case for using link feature
	ld de, StartMenuResetText
DrawStartMenu.printSaveOrResetText
	call PrintStartMenuItem
	ld de, StartMenuOptionText
	call PrintStartMenuItem
	ld de, StartMenuExitText
	call PlaceString
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ret

StartMenuPokedexText:
		.STRINGMAP pokemon, "POKéDEX@"

StartMenuPokemonText:
		.STRINGMAP pokemon, "POKéMON@"

StartMenuItemText:
		.STRINGMAP pokemon, "ITEM@"

StartMenuSaveText:
		.STRINGMAP pokemon, "SAVE@"

StartMenuResetText:
		.STRINGMAP pokemon, "RESET@"

StartMenuExitText:
		.STRINGMAP pokemon, "EXIT@"

StartMenuOptionText:
		.STRINGMAP pokemon, "OPTION@"

PrintStartMenuItem:
	push hl
	call PlaceString
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret
