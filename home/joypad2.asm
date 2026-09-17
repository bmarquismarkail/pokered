; this function is used when lower button sensitivity is wanted (e.g. menus)
; OUTPUT: [hJoy5] = pressed buttons in usual format
; there are two flags that control its functionality, [hJoy6] and [hJoy7]
; there are essentially three modes of operation
; 1. Get newly pressed buttons only
;    ([hJoy7] = 0, [hJoy6] = any)
;    Just copies [hJoyPressed] to [hJoy5].
; 2. Get currently pressed buttons at low sample rate with delay
;    ([hJoy7] = 1, [hJoy6] != 0)
;    If the user holds down buttons for more than half a second,
;    report buttons as being pressed up to 12 times per second thereafter.
;    If the user holds down buttons for less than half a second,
;    report only one button press.
; 3. Same as 2, but report no buttons as pressed if A or B is held down.
;    ([hJoy7] = 1, [hJoy6] = 0)
JoypadLowSensitivity:
	call Joypad
	ldh a, [lobyte(hJoy7)] ; flag
	and a ; get all currently pressed buttons or only newly pressed buttons?
	ldh a, [lobyte(hJoyPressed)] ; newly pressed buttons
	jr z, JoypadLowSensitivity.storeButtonState
	ldh a, [lobyte(hJoyHeld)] ; all currently pressed buttons
JoypadLowSensitivity.storeButtonState
	ldh [lobyte(hJoy5)], a
	ldh a, [lobyte(hJoyPressed)] ; newly pressed buttons
	and a ; have any buttons been newly pressed since last check?
	jr z, JoypadLowSensitivity.noNewlyPressedButtons
; newly pressed buttons
	ld a, 30 ; half a second delay
	ldh [lobyte(hFrameCounter)], a
	ret
JoypadLowSensitivity.noNewlyPressedButtons
	ldh a, [lobyte(hFrameCounter)]
	and a ; is the delay over?
	jr z, JoypadLowSensitivity.delayOver
; delay not over
	xor a
	ldh [lobyte(hJoy5)], a ; report no buttons as pressed
	ret
JoypadLowSensitivity.delayOver
; if [hJoy6] = 0 and A or B is pressed, report no buttons as pressed
	ldh a, [lobyte(hJoyHeld)]
	and PAD_A | PAD_B
	jr z, JoypadLowSensitivity.setShortDelay
	ldh a, [lobyte(hJoy6)] ; flag
	and a
	jr nz, JoypadLowSensitivity.setShortDelay
	xor a
	ldh [lobyte(hJoy5)], a
JoypadLowSensitivity.setShortDelay
	ld a, 5 ; 1/12 of a second delay
	ldh [lobyte(hFrameCounter)], a
	ret

WaitForTextScrollButtonPress:
	ldh a, [lobyte(hDownArrowBlinkCount1)]
	push af
	ldh a, [lobyte(hDownArrowBlinkCount2)]
	push af
	xor a
	ldh [lobyte(hDownArrowBlinkCount1)], a
	ld a, $6
	ldh [lobyte(hDownArrowBlinkCount2)], a
WaitForTextScrollButtonPress.loop
	push hl
	ld a, [wTownMapSpriteBlinkingEnabled]
	and a
	jr z, WaitForTextScrollButtonPress.skipAnimation
	call TownMapSpriteBlinkingAnimation
WaitForTextScrollButtonPress.skipAnimation
	hlcoord 18, 16
	call HandleDownArrowBlinkTiming
	pop hl
	call JoypadLowSensitivity
	predef CableClub_Run
	ldh a, [lobyte(hJoy5)]
	and PAD_A | PAD_B
	jr z, WaitForTextScrollButtonPress.loop
	pop af
	ldh [lobyte(hDownArrowBlinkCount2)], a
	pop af
	ldh [lobyte(hDownArrowBlinkCount1)], a
	ret

; (unless in link battle) waits for A or B being pressed and outputs the scrolling sound effect
ManualTextScroll:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, ManualTextScroll.inLinkBattle
	call WaitForTextScrollButtonPress
	ld a, SFX_PRESS_AB
	jp PlaySound
ManualTextScroll.inLinkBattle
	ld c, 65
	jp DelayFrames
