ClearVariablesOnEnterMap:
	ld a, SCREEN_HEIGHT_PX
	ldh [lobyte(hWY)], a
	ldh [lobyte(rWY)], a
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a
	ld [wStepCounter], a
	ld [wLoneAttackNo], a
	ldh [lobyte(hJoyPressed)], a
	ldh [lobyte(hJoyReleased)], a
	ldh [lobyte(hJoyHeld)], a
	ld [wActionResultOrTookBattleTurn], a
	ld [wUnusedMapVariable], a
	ld hl, wCardKeyDoorY
	ld [hli], a
	ld [hl], a
	ld hl, wWhichTrade
	ld bc, wStandingOnWarpPadOrHole - wWhichTrade
	call FillMemory
	ret
