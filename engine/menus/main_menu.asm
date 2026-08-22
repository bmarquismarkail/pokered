MainMenu:
; Check save file
	call InitOptions
	xor a
	ld [wOptionsInitialized], a
	inc a
	ld [wSaveFileStatus], a
	call CheckForPlayerNameInSRAM
	jr nc, MainMenu.mainMenuLoop

	predef TryLoadSaveFile

MainMenu.mainMenuLoop
	ld c, 20
	call DelayFrames
	xor a ; LINK_STATE_NONE
	ld [wLinkState], a
	ld hl, wPartyAndBillsPCSavedMenuItem
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [wDefaultMap], a
	ld hl, wStatusFlags4
	res BIT_LINK_CONNECTED, [hl]
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call LoadFontTilePatterns
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	ld a, [wSaveFileStatus]
	cp 1
	jr z, MainMenu.noSaveFile
; there's a save file
	hlcoord 0, 0
	ld b, 6
	ld c, 13
	call TextBoxBorder
	hlcoord 2, 2
	ld de, ContinueText
	call PlaceString
	jr MainMenu.next2
MainMenu.noSaveFile
	hlcoord 0, 0
	ld b, 4
	ld c, 13
	call TextBoxBorder
	hlcoord 2, 2
	ld de, NewGameText
	call PlaceString
MainMenu.next2
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call UpdateSprites
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld [wMenuJoypadPollCount], a
	inc a
	ld [wTopMenuItemX], a
	inc a
	ld [wTopMenuItemY], a
	ld a, PAD_A | PAD_B | PAD_START
	ld [wMenuWatchedKeys], a
	ld a, [wSaveFileStatus]
	ld [wMaxMenuItem], a
	call HandleMenuInput
	bit B_PAD_B, a
	jp nz, DisplayTitleScreen ; if so, go back to the title screen
	ld c, 20
	call DelayFrames
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wSaveFileStatus]
	cp 2
	jp z, MainMenu.skipInc
; If there's no save file, increment the current menu item so that the numbers
; are the same whether or not there's a save file.
	inc b
MainMenu.skipInc
	ld a, b
	and a
	jr z, MainMenu.choseContinue
	cp 1
	jp z, StartNewGame
	call DisplayOptionMenu
	ld a, TRUE
	ld [wOptionsInitialized], a
	jp MainMenu.mainMenuLoop
MainMenu.choseContinue
	call DisplayContinueGameInfo
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
MainMenu.inputLoop
	xor a
	ldh [lobyte(hJoyPressed)], a
	ldh [lobyte(hJoyReleased)], a
	ldh [lobyte(hJoyHeld)], a
	call Joypad
	ldh a, [lobyte(hJoyHeld)]
	bit B_PAD_A, a
	jr nz, MainMenu.pressedA
	bit B_PAD_B, a
	jp nz, MainMenu.mainMenuLoop
	jr MainMenu.inputLoop
MainMenu.pressedA
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerDirection], a
	ld c, 10
	call DelayFrames
	ld a, [wNumHoFTeams]
	and a
	jp z, SpecialEnterMap
	ld a, [wCurMap]
	cp HALL_OF_FAME
	jp nz, SpecialEnterMap
	xor a
	ld [wDestinationMap], a
	ld hl, wStatusFlags6
	set BIT_FLY_OR_DUNGEON_WARP, [hl]
	call PrepareForSpecialWarp
	jp SpecialEnterMap

InitOptions:
	ld a, 1 << BIT_FAST_TEXT_DELAY
	ld [wLetterPrintingDelayFlags], a
	ld a, TEXT_DELAY_MEDIUM
	ld [wOptions], a
	ret

LinkMenu:
	xor a
	ld [wLetterPrintingDelayFlags], a
	ld hl, wStatusFlags4
	set BIT_LINK_CONNECTED, [hl]
	ld hl, LinkMenuEmptyText
	call PrintText
	call SaveScreenTilesToBuffer1
	ld hl, WhereWouldYouLikeText
	call PrintText
	hlcoord 5, 5
	ld b, $6
	ld c, $d
	call TextBoxBorder
	call UpdateSprites
	hlcoord 7, 7
	ld de, CableClubOptionsText
	call PlaceString
	xor a
	ld [wUnusedLinkMenuByte], a
	ld [wCableClubDestinationMap], a
	ld hl, wTopMenuItemY
	ld a, 7
	ld [hli], a
	ld a, 6
	ld [hli], a
	xor a
	ld [hli], a
	inc hl
	ld a, 2
	ld [hli], a
	.ASSERT ((2 + 1)-(PAD_A | PAD_B)) < 1 && ((2 + 1)-(PAD_A | PAD_B)) > -1
	inc a
	ld [hli], a
	xor a
	ld [hl], a
LinkMenu.waitForInputLoop
	call HandleMenuInput
	and PAD_A | PAD_B
	add a
	add a
	ld b, a
	ld a, [wCurrentMenuItem]
	add b
	add $d0
	ld [wLinkMenuSelectionSendBuffer], a
	ld [wLinkMenuSelectionSendBuffer + 1], a
LinkMenu.exchangeMenuSelectionLoop
	call Serial_ExchangeLinkMenuSelection
	ld a, [wLinkMenuSelectionReceiveBuffer]
	ld b, a
	and $f0
	cp $d0
	jr z, LinkMenu.checkEnemyMenuSelection
	ld a, [wLinkMenuSelectionReceiveBuffer + 1]
	ld b, a
	and $f0
	cp $d0
	jr nz, LinkMenu.exchangeMenuSelectionLoop
LinkMenu.checkEnemyMenuSelection
	ld a, b
	and $c ; did the enemy press A or B?
	jr nz, LinkMenu.enemyPressedAOrB
; the enemy didn't press A or B
	ld a, [wLinkMenuSelectionSendBuffer]
	and $c ; did the player press A or B?
	jr z, LinkMenu.waitForInputLoop ; if neither the player nor the enemy pressed A or B, try again
	jr LinkMenu.doneChoosingMenuSelection ; if the player pressed A or B but the enemy didn't, use the player's selection
LinkMenu.enemyPressedAOrB
	ld a, [wLinkMenuSelectionSendBuffer]
	and $c ; did the player press A or B?
	jr z, LinkMenu.useEnemyMenuSelection ; if the enemy pressed A or B but the player didn't, use the enemy's selection
; the enemy and the player both pressed A or B
; The gameboy that is clocking the connection wins.
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_INTERNAL_CLOCK
	jr z, LinkMenu.doneChoosingMenuSelection
LinkMenu.useEnemyMenuSelection
	ld a, b
	ld [wLinkMenuSelectionSendBuffer], a
	and $3
	ld [wCurrentMenuItem], a
LinkMenu.doneChoosingMenuSelection
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_INTERNAL_CLOCK
	jr nz, LinkMenu.skipStartingTransfer
	call DelayFrame
	call DelayFrame
	ld a, SC_START | SC_INTERNAL
	ldh [lobyte(rSC)], a
LinkMenu.skipStartingTransfer
	ld b, $7f
	ld c, $7f
	ld d, $ec
	ld a, [wLinkMenuSelectionSendBuffer]
	and PAD_B << 2 ; was B button pressed?
	jr nz, LinkMenu.updateCursorPosition
; A button was pressed
	ld a, [wCurrentMenuItem]
	cp $2
	jr z, LinkMenu.updateCursorPosition
	ld c, d
	ld d, b
	dec a
	jr z, LinkMenu.updateCursorPosition
	ld b, c
	ld c, d
LinkMenu.updateCursorPosition
	ld a, b
	ldcoord_a 6, 7
	ld a, c
	ldcoord_a 6, 9
	ld a, d
	ldcoord_a 6, 11
	ld c, 40
	call DelayFrames
	call LoadScreenTilesFromBuffer1
	ld a, [wLinkMenuSelectionSendBuffer]
	and PAD_B << 2 ; was B button pressed?
	jr nz, LinkMenu.choseCancel ; cancel if B pressed
	ld a, [wCurrentMenuItem]
	cp $2
	jr z, LinkMenu.choseCancel
	xor a
	ld [wWalkBikeSurfState], a ; start walking
	ld a, [wCurrentMenuItem]
	and a
	ld a, COLOSSEUM
	jr nz, LinkMenu.next
	ld a, TRADE_CENTER
LinkMenu.next
	ld [wCableClubDestinationMap], a
	ld hl, PleaseWaitText
	call PrintText
	ld c, 50
	call DelayFrames
	ld hl, wStatusFlags6
	res BIT_DEBUG_MODE, [hl]
	ld a, [wDefaultMap]
	ld [wDestinationMap], a
	call PrepareForSpecialWarp
	ld c, 20
	call DelayFrames
	xor a
	ld [wMenuJoypadPollCount], a
	ld [wSerialExchangeNybbleSendData], a
	inc a ; LINK_STATE_IN_CABLE_CLUB
	ld [wLinkState], a
	ld [wEnteringCableClub], a
	jr SpecialEnterMap
LinkMenu.choseCancel
	xor a
	ld [wMenuJoypadPollCount], a
	vc_hook Wireless_net_stop
	call Delay3
	call CloseLinkConnection
	ld hl, LinkCanceledText
	vc_hook Wireless_net_end
	call PrintText
	ld hl, wStatusFlags4
	res BIT_LINK_CONNECTED, [hl]
	ret

WhereWouldYouLikeText:
	text_far WLA_GLOBAL_WhereWouldYouLikeText
	text_end

PleaseWaitText:
	text_far WLA_GLOBAL_PleaseWaitText
	text_end

LinkCanceledText:
	text_far WLA_GLOBAL_LinkCanceledText
	text_end

StartNewGame:
	ld hl, wStatusFlags6
	; Ensure debug mode is not used when starting a regular new game.
	; Debug mode persists in saved games for both debug and non-debug builds, and is
	; only reset here by the main menu.
	res BIT_DEBUG_MODE, [hl]
	; fallthrough
StartNewGameDebug:
	call OakSpeech
	ld c, 20
	call DelayFrames

; enter map after using a special warp or loading the game from the main menu
SpecialEnterMap:
	xor a
	ldh [lobyte(hJoyPressed)], a
	ldh [lobyte(hJoyHeld)], a
	ldh [lobyte(hJoy5)], a
	ld [wCableClubDestinationMap], a
	ld hl, wStatusFlags6
	set BIT_GAME_TIMER_COUNTING, [hl]
	call ResetPlayerSpriteData
	ld c, 20
	call DelayFrames
	ld a, [wEnteringCableClub]
	and a
	ret nz
	jp EnterMap

ContinueText:
		.STRINGMAP pokemon, "CONTINUE"
	next ""
	; fallthrough

NewGameText:
		.STRINGMAP pokemon, "NEW GAME"
	next "OPTION@"

CableClubOptionsText:
		.STRINGMAP pokemon, "TRADE CENTER"
	next "COLOSSEUM"
	next "CANCEL@"

DisplayContinueGameInfo:
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	hlcoord 4, 7
	ld b, 8
	ld c, 14
	call TextBoxBorder
	hlcoord 5, 9
	ld de, SaveScreenInfoText
	call PlaceString
	hlcoord 12, 9
	ld de, wPlayerName
	call PlaceString
	hlcoord 17, 11
	call PrintNumBadges
	hlcoord 16, 13
	call PrintNumOwnedMons
	hlcoord 13, 15
	call PrintPlayTime
	ld a, 1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld c, 30
	jp DelayFrames

PrintSaveScreenText:
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	hlcoord 4, 0
	ld b, $8
	ld c, $e
	call TextBoxBorder
	call LoadTextBoxTilePatterns
	call UpdateSprites
	hlcoord 5, 2
	ld de, SaveScreenInfoText
	call PlaceString
	hlcoord 12, 2
	ld de, wPlayerName
	call PlaceString
	hlcoord 17, 4
	call PrintNumBadges
	hlcoord 16, 6
	call PrintNumOwnedMons
	hlcoord 13, 8
	call PrintPlayTime
	ld a, $1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld c, 30
	jp DelayFrames

PrintNumBadges:
	push hl
	ld hl, wObtainedBadges
	ld b, $1
	call CountSetBits
	pop hl
	ld de, wNumSetBits
	lb "bc", 1, 2
	jp PrintNumber

PrintNumOwnedMons:
	push hl
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	pop hl
	ld de, wNumSetBits
	lb "bc", 1, 3
	jp PrintNumber

PrintPlayTime:
	ld de, wPlayTimeHours
	lb "bc", 1, 3
	call PrintNumber
	ld [hl], $6d
	inc hl
	ld de, wPlayTimeMinutes
	lb "bc", LEADING_ZEROES | 1, 2
	jp PrintNumber

SaveScreenInfoText:
		.STRINGMAP pokemon, "PLAYER"
	next "BADGES    "
	next "#DEX    "
	next "TIME@"

DisplayOptionMenu:
	hlcoord 0, 0
	ld b, 3
	ld c, 18
	call TextBoxBorder
	hlcoord 0, 5
	ld b, 3
	ld c, 18
	call TextBoxBorder
	hlcoord 0, 10
	ld b, 3
	ld c, 18
	call TextBoxBorder
	hlcoord 1, 1
	ld de, TextSpeedOptionText
	call PlaceString
	hlcoord 1, 6
	ld de, BattleAnimationOptionText
	call PlaceString
	hlcoord 1, 11
	ld de, BattleStyleOptionText
	call PlaceString
	hlcoord 2, 16
	ld de, OptionMenuCancelText
	call PlaceString
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	.ASSERT ((BIT_FAST_TEXT_DELAY)-(0)) < 1 && ((BIT_FAST_TEXT_DELAY)-(0)) > -1
	inc a ; 1 << BIT_FAST_TEXT_DELAY
	ld [wLetterPrintingDelayFlags], a
	ld [wOptionsCancelCursorX], a
	ld a, 3 ; text speed cursor Y coordinate
	ld [wTopMenuItemY], a
	call SetCursorPositionsFromOptions
	ld a, [wOptionsTextSpeedCursorX] ; text speed cursor X coordinate
	ld [wTopMenuItemX], a
	ld a, $01
	ldh [lobyte(hAutoBGTransferEnabled)], a ; enable auto background transfer
	call Delay3
DisplayOptionMenu.loop
	call PlaceMenuCursor
	call SetOptionsFromCursorPositions
DisplayOptionMenu.getJoypadStateLoop
	call JoypadLowSensitivity
	ldh a, [lobyte(hJoy5)]
	ld b, a
	and ~PAD_SELECT ; any key besides select pressed?
	jr z, DisplayOptionMenu.getJoypadStateLoop
	bit B_PAD_B, b
	jr nz, DisplayOptionMenu.exitMenu
	bit B_PAD_START, b
	jr nz, DisplayOptionMenu.exitMenu
	bit B_PAD_A, b
	jr z, DisplayOptionMenu.checkDirectionKeys
; A was pressed
	ld a, [wTopMenuItemY]
	cp 16 ; is the cursor on Cancel?
	jr nz, DisplayOptionMenu.loop
DisplayOptionMenu.exitMenu
	ld a, SFX_PRESS_AB
	call PlaySound
	ret
DisplayOptionMenu.eraseOldMenuCursor
	ld [wTopMenuItemX], a
	call EraseMenuCursor
	jp DisplayOptionMenu.loop
DisplayOptionMenu.checkDirectionKeys
	ld a, [wTopMenuItemY]
	bit B_PAD_DOWN, b
	jr nz, DisplayOptionMenu.downPressed
	bit B_PAD_UP, b
	jr nz, DisplayOptionMenu.upPressed
	cp 8 ; cursor in Battle Animation section?
	jr z, DisplayOptionMenu.cursorInBattleAnimation
	cp 13 ; cursor in Battle Style section?
	jr z, DisplayOptionMenu.cursorInBattleStyle
	cp 16 ; cursor on Cancel?
	jr z, DisplayOptionMenu.loop
; cursor in Text Speed
	bit B_PAD_LEFT, b
	jp nz, DisplayOptionMenu.pressedLeftInTextSpeed
	jp DisplayOptionMenu.pressedRightInTextSpeed
DisplayOptionMenu.downPressed
	cp 16
	ld b, -13
	ld hl, wOptionsTextSpeedCursorX
	jr z, DisplayOptionMenu.updateMenuVariables
	ld b, 5
	cp 3
	inc hl
	jr z, DisplayOptionMenu.updateMenuVariables
	cp 8
	inc hl
	jr z, DisplayOptionMenu.updateMenuVariables
	ld b, 3
	inc hl
	jr DisplayOptionMenu.updateMenuVariables
DisplayOptionMenu.upPressed
	cp 8
	ld b, -5
	ld hl, wOptionsTextSpeedCursorX
	jr z, DisplayOptionMenu.updateMenuVariables
	cp 13
	inc hl
	jr z, DisplayOptionMenu.updateMenuVariables
	cp 16
	ld b, -3
	inc hl
	jr z, DisplayOptionMenu.updateMenuVariables
	ld b, 13
	inc hl
DisplayOptionMenu.updateMenuVariables
	add b
	ld [wTopMenuItemY], a
	ld a, [hl]
	ld [wTopMenuItemX], a
	call PlaceUnfilledArrowMenuCursor
	jp DisplayOptionMenu.loop
DisplayOptionMenu.cursorInBattleAnimation
	ld a, [wOptionsBattleAnimCursorX] ; battle animation cursor X coordinate
	xor 1 ~ 10 ; toggle between 1 and 10
	ld [wOptionsBattleAnimCursorX], a
	jp DisplayOptionMenu.eraseOldMenuCursor
DisplayOptionMenu.cursorInBattleStyle
	ld a, [wOptionsBattleStyleCursorX] ; battle style cursor X coordinate
	xor 1 ~ 10 ; toggle between 1 and 10
	ld [wOptionsBattleStyleCursorX], a
	jp DisplayOptionMenu.eraseOldMenuCursor
DisplayOptionMenu.pressedLeftInTextSpeed
	ld a, [wOptionsTextSpeedCursorX] ; text speed cursor X coordinate
	cp 1
	jr z, DisplayOptionMenu.updateTextSpeedXCoord
	cp 7
	jr nz, DisplayOptionMenu.fromSlowToMedium
	sub 6
	jr DisplayOptionMenu.updateTextSpeedXCoord
DisplayOptionMenu.fromSlowToMedium
	sub 7
	jr DisplayOptionMenu.updateTextSpeedXCoord
DisplayOptionMenu.pressedRightInTextSpeed
	ld a, [wOptionsTextSpeedCursorX] ; text speed cursor X coordinate
	cp 14
	jr z, DisplayOptionMenu.updateTextSpeedXCoord
	cp 7
	jr nz, DisplayOptionMenu.fromFastToMedium
	add 7
	jr DisplayOptionMenu.updateTextSpeedXCoord
DisplayOptionMenu.fromFastToMedium
	add 6
DisplayOptionMenu.updateTextSpeedXCoord
	ld [wOptionsTextSpeedCursorX], a ; text speed cursor X coordinate
	jp DisplayOptionMenu.eraseOldMenuCursor

TextSpeedOptionText:
		.STRINGMAP pokemon, "TEXT SPEED"
	next " FAST  MEDIUM SLOW@"

BattleAnimationOptionText:
		.STRINGMAP pokemon, "BATTLE ANIMATION"
	next " ON       OFF@"

BattleStyleOptionText:
		.STRINGMAP pokemon, "BATTLE STYLE"
	next " SHIFT    SET@"

OptionMenuCancelText:
		.STRINGMAP pokemon, "CANCEL@"

; sets the options variable according to the current placement of the menu cursors in the options menu
SetOptionsFromCursorPositions:
	ld hl, TextSpeedOptionData
	ld a, [wOptionsTextSpeedCursorX] ; text speed cursor X coordinate
	ld c, a
SetOptionsFromCursorPositions.loop
	ld a, [hli]
	cp c
	jr z, SetOptionsFromCursorPositions.textSpeedMatchFound
	inc hl
	jr SetOptionsFromCursorPositions.loop
SetOptionsFromCursorPositions.textSpeedMatchFound
	ld a, [hl]
	ld d, a
	ld a, [wOptionsBattleAnimCursorX] ; battle animation cursor X coordinate
	dec a
	jr z, SetOptionsFromCursorPositions.battleAnimationOn
; battle animation Off
	set BIT_BATTLE_ANIMATION, d
	jr SetOptionsFromCursorPositions.checkBattleStyle
SetOptionsFromCursorPositions.battleAnimationOn
	res BIT_BATTLE_ANIMATION, d
SetOptionsFromCursorPositions.checkBattleStyle
	ld a, [wOptionsBattleStyleCursorX] ; battle style cursor X coordinate
	dec a
	jr z, SetOptionsFromCursorPositions.battleStyleShift
; battle style Set
	set BIT_BATTLE_SHIFT, d
	jr SetOptionsFromCursorPositions.storeOptions
SetOptionsFromCursorPositions.battleStyleShift
	res BIT_BATTLE_SHIFT, d
SetOptionsFromCursorPositions.storeOptions
	ld a, d
	ld [wOptions], a
	ret

; reads the options variable and places menu cursors in the correct positions within the options menu
SetCursorPositionsFromOptions:
	ld hl, TextSpeedOptionData + 1
	ld a, [wOptions]
	ld c, a
	and $3f
	push bc
	ld de, 2
	call IsInArray
	pop bc
	dec hl
	ld a, [hl]
	ld [wOptionsTextSpeedCursorX], a ; text speed cursor X coordinate
	hlcoord 0, 3
	call SetCursorPositionsFromOptions.placeUnfilledRightArrow
	sla c
	ld a, 1 ; On
	jr nc, SetCursorPositionsFromOptions.storeBattleAnimationCursorX
	ld a, 10 ; Off
SetCursorPositionsFromOptions.storeBattleAnimationCursorX
	ld [wOptionsBattleAnimCursorX], a ; battle animation cursor X coordinate
	hlcoord 0, 8
	call SetCursorPositionsFromOptions.placeUnfilledRightArrow
	sla c
	ld a, 1
	jr nc, SetCursorPositionsFromOptions.storeBattleStyleCursorX
	ld a, 10
SetCursorPositionsFromOptions.storeBattleStyleCursorX
	ld [wOptionsBattleStyleCursorX], a ; battle style cursor X coordinate
	hlcoord 0, 13
	call SetCursorPositionsFromOptions.placeUnfilledRightArrow
; cursor in front of Cancel
	hlcoord 0, 16
	ld a, 1
SetCursorPositionsFromOptions.placeUnfilledRightArrow
	ld e, a
	ld d, 0
	add hl, de
	ld [hl], $ec
	ret

; table that indicates how the 3 text speed options affect frame delays
; Format:
; 00: X coordinate of menu cursor
; 01: delay after printing a letter (in frames)
TextSpeedOptionData:
	.DB 14, TEXT_DELAY_SLOW
	.DB  7, TEXT_DELAY_MEDIUM
	.DB  1, TEXT_DELAY_FAST
	.DB  7, -1 ; end (default X coordinate)

CheckForPlayerNameInSRAM:
; Check if the player name data in SRAM has a string terminator character
; (indicating that a name may have been saved there) and return whether it does
; in carry.
	ld a, RAMG_SRAM_ENABLE
	ld [rRAMG], a
	ld a, BMODE_ADVANCED
	ld [rBMODE], a
	ld [rRAMB], a
	ld b, NAME_LENGTH
	ld hl, sPlayerName
CheckForPlayerNameInSRAM.loop
	ld a, [hli]
	cp $50
	jr z, CheckForPlayerNameInSRAM.found
	dec b
	jr nz, CheckForPlayerNameInSRAM.loop
; not found
	xor a
	ld [rRAMG], a
	ld [rBMODE], a
	and a
	ret
CheckForPlayerNameInSRAM.found
	xor a
	ld [rRAMG], a
	ld [rBMODE], a
	scf
	ret
