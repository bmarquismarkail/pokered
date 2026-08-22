PrintBlackboardLinkCableText:
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, [wHiddenEventFunctionArgument]
	call PrintPredefTextID
	ret

LinkCableHelp:
	text_asm
	call SaveScreenTilesToBuffer1
	ld hl, LinkCableHelpText1
	call PrintText
	xor a
	ld [wMenuItemOffset], a ; not used
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, 3
	ld [wMaxMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
LinkCableHelp.linkHelpLoop
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 0, 0
	ld b, 8
	ld c, 13
	call TextBoxBorder
	hlcoord 2, 2
	ld de, HowToLinkText
	call PlaceString
	ld hl, LinkCableHelpText2
	call PrintText
	call HandleMenuInput
	bit B_PAD_B, a
	jr nz, LinkCableHelp.exit
	ld a, [wCurrentMenuItem]
	cp 3 ; pressed a on "STOP READING"
	jr z, LinkCableHelp.exit
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ld hl, LinkCableInfoTexts
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	jp LinkCableHelp.linkHelpLoop
LinkCableHelp.exit
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call LoadScreenTilesFromBuffer1
	jp TextScriptEnd

LinkCableHelpText1:
	text_far WLA_GLOBAL_LinkCableHelpText1
	text_end

LinkCableHelpText2:
	text_far WLA_GLOBAL_LinkCableHelpText2
	text_end

HowToLinkText:
		.STRINGMAP pokemon, "HOW TO LINK"
	next "COLOSSEUM"
	next "TRADE CENTER"
	next "STOP READING@"

LinkCableInfoTexts:
	.DW LinkCableInfoText1
	.DW LinkCableInfoText2
	.DW LinkCableInfoText3

LinkCableInfoText1:
	text_far WLA_GLOBAL_LinkCableInfoText1
	text_end

LinkCableInfoText2:
	text_far WLA_GLOBAL_LinkCableInfoText2
	text_end

LinkCableInfoText3:
	text_far WLA_GLOBAL_LinkCableInfoText3
	text_end

ViridianSchoolBlackboard:
	text_asm
	call SaveScreenTilesToBuffer1
	ld hl, ViridianSchoolBlackboardText1
	call PrintText
	xor a
	ld [wMenuItemOffset], a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, PAD_LEFT | PAD_RIGHT | PAD_A | PAD_B
	ld [wMenuWatchedKeys], a
	ld a, 2
	ld [wMaxMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
ViridianSchoolBlackboard.blackboardLoop
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	hlcoord 0, 0
	lb "bc", 6, 10
	call TextBoxBorder
	hlcoord 1, 2
	ld de, StatusAilmentText1
	call PlaceString
	hlcoord 6, 2
	ld de, StatusAilmentText2
	call PlaceString
	ld hl, ViridianSchoolBlackboardText2
	call PrintText
	call HandleMenuInput ; pressing up and down is handled in here
	bit B_PAD_B, a ; pressed b
	jr nz, ViridianSchoolBlackboard.exitBlackboard
	bit B_PAD_RIGHT, a
	jr z, ViridianSchoolBlackboard.didNotPressRight
	; move cursor to right column
	ld a, 2
	ld [wMaxMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 6
	ld [wTopMenuItemX], a
	ld a, 3 ; in the the right column, use an offset to prevent overlap
	ld [wMenuItemOffset], a
	jr ViridianSchoolBlackboard.blackboardLoop
ViridianSchoolBlackboard.didNotPressRight
	bit B_PAD_LEFT, a
	jr z, ViridianSchoolBlackboard.didNotPressLeftOrRight
	; move cursor to left column
	ld a, 2
	ld [wMaxMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	xor a
	ld [wMenuItemOffset], a
	jr ViridianSchoolBlackboard.blackboardLoop
ViridianSchoolBlackboard.didNotPressLeftOrRight
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wMenuItemOffset]
	add b
	cp 5 ; cursor is pointing to "QUIT"
	jr z, ViridianSchoolBlackboard.exitBlackboard
	; we must have pressed a on a status condition
	; so print the text
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	ld hl, ViridianBlackboardStatusPointers
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	jp ViridianSchoolBlackboard.blackboardLoop
ViridianSchoolBlackboard.exitBlackboard
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call LoadScreenTilesFromBuffer1
	jp TextScriptEnd

ViridianSchoolBlackboardText1:
	text_far WLA_GLOBAL_ViridianSchoolBlackboardText1
	text_end

ViridianSchoolBlackboardText2:
	text_far WLA_GLOBAL_ViridianSchoolBlackboardText2
	text_end

StatusAilmentText1:
		.STRINGMAP pokemon, " SLP"
	next " PSN"
	next " PAR@"

StatusAilmentText2:
		.STRINGMAP pokemon, " BRN"
	next " FRZ"
	next " QUIT@"

		.STRINGMAP pokemon, "@" ; unused

ViridianBlackboardStatusPointers:
	.DW ViridianBlackboardSleepText
	.DW ViridianBlackboardPoisonText
	.DW ViridianBlackboardPrlzText
	.DW ViridianBlackboardBurnText
	.DW ViridianBlackboardFrozenText

ViridianBlackboardSleepText:
	text_far WLA_GLOBAL_ViridianBlackboardSleepText
	text_end

ViridianBlackboardPoisonText:
	text_far WLA_GLOBAL_ViridianBlackboardPoisonText
	text_end

ViridianBlackboardPrlzText:
	text_far WLA_GLOBAL_ViridianBlackboardPrlzText
	text_end

ViridianBlackboardBurnText:
	text_far WLA_GLOBAL_ViridianBlackboardBurnText
	text_end

ViridianBlackboardFrozenText:
	text_far WLA_GLOBAL_ViridianBlackboardFrozenText
	text_end
