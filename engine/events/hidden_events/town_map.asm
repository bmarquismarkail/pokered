TownMapText:
	text_far WLA_GLOBAL_TownMapText
	text_promptbutton
	text_asm
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	call GBPalWhiteOutWithDelay3
	xor a
	ldh [lobyte(hWY)], a
	inc a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call LoadFontTilePatterns
	farcall DisplayTownMap
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ld de, TextScriptEnd
	push de
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	jp CloseTextDisplay
