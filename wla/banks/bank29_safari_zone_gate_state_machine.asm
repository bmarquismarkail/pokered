SafariZoneGatePlayerMovingRightScript:
	CALL SafariZoneGateReturnSimulatedJoypadStateScript
	RET NZ
SafariZoneGateWouldYouLikeToJoinScript:
	XOR A
	LDH ($B4), A ; hJoyHeld
	LD ($CD6B), A ; wJoyIgnore
	CALL $2429 ; UpdateSprites
	LD A, 4
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	LD A, $FF ; PAD_BUTTONS | PAD_CTRL_PAD
	LD ($CD6B), A ; wJoyIgnore
	RET

SafariZoneGatePlayerMovingUpScript:
	CALL SafariZoneGateReturnSimulatedJoypadStateScript
	RET NZ
	XOR A
	LD ($CD6B), A ; wJoyIgnore
	LD A, 5 ; SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI
	LD ($D61F), A ; wSafariZoneGateCurScript
	RET

SafariZoneGateLeavingSafariScript:
	LD A, 4 ; PLAYER_DIR_DOWN
	LD ($D528), A ; wPlayerMovingDirection
	LD HL, $D790
	BIT 6, (HL) ; EVENT_SAFARI_GAME_OVER
	RES 6, (HL)
	JR Z, SafariZoneGateLeavingSafariScript.leaving_early
	RES 7, (HL) ; EVENT_IN_SAFARI_ZONE
	CALL $2429 ; UpdateSprites
	LD A, $F0 ; PAD_CTRL_PAD
	LD ($CD6B), A ; wJoyIgnore
	LD A, 6
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	XOR A
	LD ($DA47), A ; wNumSafariBalls
	LD A, $80 ; PAD_DOWN
	LD C, 3
	CALL SafariZoneEntranceAutoWalk
	LD A, 4 ; SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_DOWN
	LD ($D61F), A ; wSafariZoneGateCurScript
	JR SafariZoneGateLeavingSafariScript.return
SafariZoneGateLeavingSafariScript.leaving_early:
	LD A, 5
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
SafariZoneGateLeavingSafariScript.return:
	RET

SafariZoneGatePlayerMovingDownScript:
	CALL SafariZoneGateReturnSimulatedJoypadStateScript
	RET NZ
	XOR A
	LD ($CD6B), A ; wJoyIgnore
	LD A, 0 ; SCRIPT_SAFARIZONEGATE_DEFAULT
	LD ($D61F), A ; wSafariZoneGateCurScript
	RET

SafariZoneGateSetScriptAfterMoveScript:
	CALL SafariZoneGateReturnSimulatedJoypadStateScript
	RET NZ
	CALL $3DD7 ; Delay3
	LD A, ($CF0D) ; wNextSafariZoneGateScript
	LD ($D61F), A ; wSafariZoneGateCurScript
	RET

SafariZoneEntranceAutoWalk:
	PUSH AF
	LD B, 0
	LD A, C
	LD ($CD38), A ; wSimulatedJoypadStatesIndex
	LD HL, $CCD3 ; wSimulatedJoypadStatesEnd
	POP AF
	CALL $36E0 ; FillMemory
	JP $3486 ; StartSimulatingJoypadStates

SafariZoneGateReturnSimulatedJoypadStateScript:
	LD A, ($CD38) ; wSimulatedJoypadStatesIndex
	AND A
	RET
SafariZoneGateStateMachineEnd:
.ASSERT SafariZoneGateStateMachineEnd - SafariZoneGatePlayerMovingRightScript == 147
