; This function is used to wait a short period after printing a letter to the
; screen unless the player presses the A/B button or the delay is turned off
; through the [wStatusFlags5] or [wLetterPrintingDelayFlags] flags.
PrintLetterDelay:
	ld a, [wStatusFlags5]
	bit BIT_NO_TEXT_DELAY, a
	ret nz
	ld a, [wLetterPrintingDelayFlags]
	bit BIT_TEXT_DELAY, a
	ret z
	push hl
	push de
	push bc
	ld a, [wLetterPrintingDelayFlags]
	bit BIT_FAST_TEXT_DELAY, a
	jr z, PrintLetterDelay.waitOneFrame
	ld a, [wOptions]
	and $f
	ldh [lobyte(hFrameCounter)], a
	jr PrintLetterDelay.checkButtons
PrintLetterDelay.waitOneFrame
	ld a, 1
	ldh [lobyte(hFrameCounter)], a
PrintLetterDelay.checkButtons
	call Joypad
	ldh a, [lobyte(hJoyHeld)]
; check A button
	bit B_PAD_A, a
	jr z, PrintLetterDelay.checkBButton
	jr PrintLetterDelay.endWait
PrintLetterDelay.checkBButton
	bit B_PAD_B, a
	jr z, PrintLetterDelay.buttonsNotPressed
PrintLetterDelay.endWait
	call DelayFrame
	jr PrintLetterDelay.done
PrintLetterDelay.buttonsNotPressed ; if neither A nor B is pressed
	ldh a, [lobyte(hFrameCounter)]
	and a
	jr nz, PrintLetterDelay.checkButtons
PrintLetterDelay.done
	pop bc
	pop de
	pop hl
	ret
