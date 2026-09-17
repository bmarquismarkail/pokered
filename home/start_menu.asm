DisplayStartMenu:
	ld a, bank(StartMenu_Pokedex)
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ld a, [wWalkBikeSurfState] ; walking/biking/surfing
	ld [wWalkBikeSurfStateCopy], a
	ld a, SFX_START_MENU
	call PlaySound

RedisplayStartMenu:
	farcall DrawStartMenu
	farcall PrintSafariZoneSteps ; print Safari Zone info, if in Safari Zone
	call UpdateSprites
RedisplayStartMenu.loop
	call HandleMenuInput
	ld b, a
; check if Up pressed
	bit B_PAD_UP, a
	jr z, RedisplayStartMenu.checkIfDownPressed
	ld a, [wCurrentMenuItem] ; menu selection
	and a
	jr nz, RedisplayStartMenu.loop
	ld a, [wLastMenuItem]
	and a
	jr nz, RedisplayStartMenu.loop
; if the player pressed tried to go past the top item, wrap around to the bottom
	CheckEvent EVENT_GOT_POKEDEX
	ld a, 6 ; there are 7 menu items with the pokedex, so the max index is 6
	jr nz, RedisplayStartMenu.wrapMenuItemId
	dec a ; there are only 6 menu items without the pokedex
RedisplayStartMenu.wrapMenuItemId
	ld [wCurrentMenuItem], a
	call EraseMenuCursor
	jr RedisplayStartMenu.loop
RedisplayStartMenu.checkIfDownPressed
	bit B_PAD_DOWN, a
	jr z, RedisplayStartMenu.buttonPressed
; if the player pressed tried to go past the bottom item, wrap around to the top
	CheckEvent EVENT_GOT_POKEDEX
	ld a, [wCurrentMenuItem]
	ld c, 7 ; there are 7 menu items with the pokedex
	jr nz, RedisplayStartMenu.checkIfPastBottom
	dec c ; there are only 6 menu items without the pokedex
RedisplayStartMenu.checkIfPastBottom
	cp c
	jr nz, RedisplayStartMenu.loop
; the player went past the bottom, so wrap to the top
	xor a
	ld [wCurrentMenuItem], a
	call EraseMenuCursor
	jr RedisplayStartMenu.loop
RedisplayStartMenu.buttonPressed ; A, B, or Start button pressed
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	ld [wBattleAndStartSavedMenuItem], a ; save current menu selection
	ld a, b
	and PAD_B | PAD_START ; was the Start button or B button pressed?
	jp nz, CloseStartMenu
	call SaveScreenTilesToBuffer2 ; copy background from wTileMap to wTileMapBackup2
	CheckEvent EVENT_GOT_POKEDEX
	ld a, [wCurrentMenuItem]
	jr nz, RedisplayStartMenu.displayMenuItem
	inc a ; adjust position to account for missing pokedex menu item
RedisplayStartMenu.displayMenuItem
	cp 0
	jp z, StartMenu_Pokedex
	cp 1
	jp z, StartMenu_Pokemon
	cp 2
	jp z, StartMenu_Item
	cp 3
	jp z, StartMenu_TrainerInfo
	cp 4
	jp z, StartMenu_SaveReset
	cp 5
	jp z, StartMenu_Option

; EXIT falls through to here
CloseStartMenu:
	call Joypad
	ldh a, [lobyte(hJoyPressed)]
	bit B_PAD_A, a
	jr nz, CloseStartMenu
	call LoadTextBoxTilePatterns
	jp CloseTextDisplay
