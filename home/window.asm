HandleMenuInput:
	xor a
	ld [wPartyMenuAnimMonEnabled], a

HandleMenuInput_:
	ldh a, [lobyte(hDownArrowBlinkCount1)]
	push af
	ldh a, [lobyte(hDownArrowBlinkCount2)]
	push af ; save existing values on stack
	xor a
	ldh [lobyte(hDownArrowBlinkCount1)], a ; blinking down arrow timing value 1
	ld a, 6
	ldh [lobyte(hDownArrowBlinkCount2)], a ; blinking down arrow timing value 2
HandleMenuInput_.loop1
	xor a
	ld [wAnimCounter], a ; counter for pokemon shaking animation
	call PlaceMenuCursor
	call Delay3
HandleMenuInput_.loop2
	push hl
	ld a, [wPartyMenuAnimMonEnabled]
	and a ; is it a pokemon selection menu?
	jr z, HandleMenuInput_.getJoypadState
	farcall AnimatePartyMon ; shake mini sprite of selected pokemon
HandleMenuInput_.getJoypadState
	pop hl
	call JoypadLowSensitivity
	ldh a, [lobyte(hJoy5)]
	and a ; was a key pressed?
	jr nz, HandleMenuInput_.keyPressed
	push hl
	hlcoord 18, 11 ; coordinates of blinking down arrow in some menus
	call HandleDownArrowBlinkTiming ; blink down arrow (if any)
	pop hl
	ld a, [wMenuJoypadPollCount]
	dec a
	jr z, HandleMenuInput_.giveUpWaiting
	jr HandleMenuInput_.loop2
HandleMenuInput_.giveUpWaiting
; if a key wasn't pressed within the specified number of checks
	pop af
	ldh [lobyte(hDownArrowBlinkCount2)], a
	pop af
	ldh [lobyte(hDownArrowBlinkCount1)], a ; restore previous values
	xor a
	ld [wMenuWrappingEnabled], a ; disable menu wrapping
	ret
HandleMenuInput_.keyPressed
	xor a
	ld [wCheckFor180DegreeTurn], a
	ldh a, [lobyte(hJoy5)]
	ld b, a
	bit B_PAD_UP, a
	jr z, HandleMenuInput_.checkIfDownPressed
; Up pressed
	ld a, [wCurrentMenuItem] ; selected menu item
	and a ; already at the top of the menu?
	jr z, HandleMenuInput_.alreadyAtTop
; not at top
	dec a
	ld [wCurrentMenuItem], a ; move selected menu item up one space
	jr HandleMenuInput_.checkOtherKeys
HandleMenuInput_.alreadyAtTop
	ld a, [wMenuWrappingEnabled]
	and a ; is wrapping around enabled?
	jr z, HandleMenuInput_.noWrappingAround
	ld a, [wMaxMenuItem]
	ld [wCurrentMenuItem], a ; wrap to the bottom of the menu
	jr HandleMenuInput_.checkOtherKeys
HandleMenuInput_.checkIfDownPressed
	bit B_PAD_DOWN, a
	jr z, HandleMenuInput_.checkOtherKeys
; Down pressed
	ld a, [wCurrentMenuItem]
	inc a
	ld c, a
	ld a, [wMaxMenuItem]
	cp c
	jr nc, HandleMenuInput_.notAtBottom
; already at bottom
	ld a, [wMenuWrappingEnabled]
	and a ; is wrapping around enabled?
	jr z, HandleMenuInput_.noWrappingAround
	ld c, $00 ; wrap from bottom to top
HandleMenuInput_.notAtBottom
	ld a, c
	ld [wCurrentMenuItem], a
HandleMenuInput_.checkOtherKeys
	ld a, [wMenuWatchedKeys]
	and b ; does the menu care about any of the pressed keys?
	jp z, HandleMenuInput_.loop1
HandleMenuInput_.checkIfAButtonOrBButtonPressed
	ldh a, [lobyte(hJoy5)]
	and PAD_A | PAD_B
	jr z, HandleMenuInput_.skipPlayingSound
; A or B pressed
	push hl
	ld hl, wMiscFlags
	bit BIT_NO_MENU_BUTTON_SOUND, [hl]
	pop hl
	jr nz, HandleMenuInput_.skipPlayingSound
	ld a, SFX_PRESS_AB
	call PlaySound
HandleMenuInput_.skipPlayingSound
	pop af
	ldh [lobyte(hDownArrowBlinkCount2)], a
	pop af
	ldh [lobyte(hDownArrowBlinkCount1)], a ; restore previous values
	xor a
	ld [wMenuWrappingEnabled], a ; disable menu wrapping
	ldh a, [lobyte(hJoy5)]
	ret
HandleMenuInput_.noWrappingAround
	ld a, [wMenuWatchMovingOutOfBounds]
	and a ; should we return if the user tried to go past the top or bottom?
	jr z, HandleMenuInput_.checkOtherKeys
	jr HandleMenuInput_.checkIfAButtonOrBButtonPressed

PlaceMenuCursor:
	ld a, [wTopMenuItemY]
	and a ; is the y coordinate 0?
	jr z, PlaceMenuCursor.adjustForXCoord
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
PlaceMenuCursor.topMenuItemLoop
	add hl, bc
	dec a
	jr nz, PlaceMenuCursor.topMenuItemLoop
PlaceMenuCursor.adjustForXCoord
	ld a, [wTopMenuItemX]
	ld b, 0
	ld c, a
	add hl, bc
	push hl
	ld a, [wLastMenuItem]
	and a ; was the previous menu id 0?
	jr z, PlaceMenuCursor.checkForArrow1
	push af
	ldh a, [lobyte(hUILayoutFlags)]
	bit BIT_DOUBLE_SPACED_MENU, a
	jr z, PlaceMenuCursor.doubleSpaced1
	ld bc, SCREEN_WIDTH
	jr PlaceMenuCursor.getOldMenuItemScreenPosition
PlaceMenuCursor.doubleSpaced1
	ld bc, SCREEN_WIDTH * 2
PlaceMenuCursor.getOldMenuItemScreenPosition
	pop af
PlaceMenuCursor.oldMenuItemLoop
	add hl, bc
	dec a
	jr nz, PlaceMenuCursor.oldMenuItemLoop
PlaceMenuCursor.checkForArrow1
	ld a, [hl]
	cp $ed ; was an arrow next to the previously selected menu item?
	jr nz, PlaceMenuCursor.skipClearingArrow
; clear arrow
	ld a, [wTileBehindCursor]
	ld [hl], a
PlaceMenuCursor.skipClearingArrow
	pop hl
	ld a, [wCurrentMenuItem]
	and a
	jr z, PlaceMenuCursor.checkForArrow2
	push af
	ldh a, [lobyte(hUILayoutFlags)]
	bit BIT_DOUBLE_SPACED_MENU, a
	jr z, PlaceMenuCursor.doubleSpaced2
	ld bc, SCREEN_WIDTH
	jr PlaceMenuCursor.getCurrentMenuItemScreenPosition
PlaceMenuCursor.doubleSpaced2
	ld bc, SCREEN_WIDTH * 2
PlaceMenuCursor.getCurrentMenuItemScreenPosition
	pop af
PlaceMenuCursor.currentMenuItemLoop
	add hl, bc
	dec a
	jr nz, PlaceMenuCursor.currentMenuItemLoop
PlaceMenuCursor.checkForArrow2
	ld a, [hl]
	cp $ed ; has the right arrow already been placed?
	jr z, PlaceMenuCursor.skipSavingTile ; if so, don't lose the saved tile
	ld [wTileBehindCursor], a ; save tile before overwriting with right arrow
PlaceMenuCursor.skipSavingTile
	ld a, $ed ; place right arrow
	ld [hl], a
	ld a, l
	ld [wMenuCursorLocation], a
	ld a, h
	ld [wMenuCursorLocation + 1], a
	ld a, [wCurrentMenuItem]
	ld [wLastMenuItem], a
	ret

; This is used to mark a menu cursor other than the one currently being
; manipulated. In the case of submenus, this is used to show the location of
; the menu cursor in the parent menu. In the case of swapping items in list,
; this is used to mark the item that was first chosen to be swapped.
PlaceUnfilledArrowMenuCursor:
	ld b, a
	ld a, [wMenuCursorLocation]
	ld l, a
	ld a, [wMenuCursorLocation + 1]
	ld h, a
	ld [hl], $ec
	ld a, b
	ret

; Replaces the menu cursor with a blank space.
EraseMenuCursor:
	ld a, [wMenuCursorLocation]
	ld l, a
	ld a, [wMenuCursorLocation + 1]
	ld h, a
	ld [hl], $7f
	ret

; This toggles a blinking down arrow at hl on and off after a delay has passed.
; This is often called even when no blinking is occurring.
; The reason is that most functions that call this initialize hDownArrowBlinkCount1 to 0.
; The effect is that if the tile at hl is initialized with a down arrow,
; this function will toggle that down arrow on and off, but if the tile isn't
; initialized with a down arrow, this function does nothing.
; That allows this to be called without worrying about if a down arrow should
; be blinking.
HandleDownArrowBlinkTiming:
	ld a, [hl]
	ld b, a
	ld a, $ee
	cp b
	jr nz, HandleDownArrowBlinkTiming.downArrowOff
HandleDownArrowBlinkTiming.downArrowOn
	ldh a, [lobyte(hDownArrowBlinkCount1)]
	dec a
	ldh [lobyte(hDownArrowBlinkCount1)], a
	ret nz
	ldh a, [lobyte(hDownArrowBlinkCount2)]
	dec a
	ldh [lobyte(hDownArrowBlinkCount2)], a
	ret nz
	ld a, $7f
	ld [hl], a
	ld a, $ff
	ldh [lobyte(hDownArrowBlinkCount1)], a
	ld a, $06
	ldh [lobyte(hDownArrowBlinkCount2)], a
	ret
HandleDownArrowBlinkTiming.downArrowOff
	ldh a, [lobyte(hDownArrowBlinkCount1)]
	and a
	ret z
	dec a
	ldh [lobyte(hDownArrowBlinkCount1)], a
	ret nz
	dec a
	ldh [lobyte(hDownArrowBlinkCount1)], a
	ldh a, [lobyte(hDownArrowBlinkCount2)]
	dec a
	ldh [lobyte(hDownArrowBlinkCount2)], a
	ret nz
	ld a, $06
	ldh [lobyte(hDownArrowBlinkCount2)], a
	ld a, $ee
	ld [hl], a
	ret

; The following code either enables or disables the automatic drawing of
; text boxes by DisplayTextID. Both functions cause DisplayTextID to wait
; for a button press after displaying text (unless [wEnteringCableClub] is set).

EnableAutoTextBoxDrawing:
	xor a
	jr AutoTextBoxDrawingCommon

DisableAutoTextBoxDrawing:
	ld a, 1 << BIT_NO_AUTO_TEXT_BOX

AutoTextBoxDrawingCommon:
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a ; make DisplayTextID wait for button press
	ret

PrintText:
; Print text hl at (1, 14).
	push hl
	ld a, MESSAGE_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call UpdateSprites
	call Delay3
	pop hl
PrintText_NoCreatingTextBox:
	bccoord 1, 14
	jp TextCommandProcessor
