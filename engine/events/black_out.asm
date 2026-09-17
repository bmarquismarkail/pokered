ResetStatusAndHalveMoneyOnBlackout:
; Reset player status on blackout.
	xor a
	ld [wBattleResult], a
	ld [wWalkBikeSurfState], a
	ld [wIsInBattle], a
	ld [wMapPalOffset], a
	ld [wNPCMovementScriptFunctionNum], a
	ldh [lobyte(hJoyHeld)], a
	ld [wNPCMovementScriptPointerTableNum], a
	ld [wMiscFlags], a

	ldh [lobyte(hMoney)], a
	ldh [lobyte(hMoney + 1)], a
	ldh [lobyte(hMoney + 2)], a
	call HasEnoughMoney
	jr c, ResetStatusAndHalveMoneyOnBlackout.lostmoney ; never happens

	; Halve the player's money.
	ld a, [wPlayerMoney]
	ldh [lobyte(hMoney)], a
	ld a, [wPlayerMoney + 1]
	ldh [lobyte(hMoney + 1)], a
	ld a, [wPlayerMoney + 2]
	ldh [lobyte(hMoney + 2)], a
	xor a
	ldh [lobyte(hDivideBCDDivisor)], a
	ldh [lobyte(hDivideBCDDivisor + 1)], a
	ld a, 2
	ldh [lobyte(hDivideBCDDivisor + 2)], a
	predef DivideBCDPredef3
	ldh a, [lobyte(hDivideBCDQuotient)]
	ld [wPlayerMoney], a
	ldh a, [lobyte(hDivideBCDQuotient + 1)]
	ld [wPlayerMoney + 1], a
	ldh a, [lobyte(hDivideBCDQuotient + 2)]
	ld [wPlayerMoney + 2], a

ResetStatusAndHalveMoneyOnBlackout.lostmoney
	ld hl, wStatusFlags6
	set BIT_FLY_OR_DUNGEON_WARP, [hl]
	res BIT_FLY_WARP, [hl]
	set BIT_ESCAPE_WARP, [hl]
	ld a, PAD_BUTTONS | PAD_CTRL_PAD
	ld [wJoyIgnore], a
	predef_jump HealParty
