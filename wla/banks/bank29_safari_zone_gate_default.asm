SafariZoneGateDefaultScript:
	LD HL, SafariZoneGateDefaultScript.PlayerNextToSafariZoneWorker1CoordsArray
	CALL $34BF ; ArePlayerCoordsInArray
	RET NC
	LD A, 3 ; TEXT_SAFARIZONEGATE_SAFARI_ZONE_WORKER1_1
	LDH ($8C), A ; hTextID
	CALL $2920 ; DisplayTextID
	LD A, $FF ; PAD_BUTTONS | PAD_CTRL_PAD
	LD ($CD6B), A ; wJoyIgnore
	XOR A
	LDH ($B4), A ; hJoyHeld
	LD A, $0C ; SPRITE_FACING_RIGHT
	LD ($C109), A ; wSpritePlayerStateData1FacingDirection
	LD A, ($CD3D) ; wCoordIndex
	CP 1
	JR Z, SafariZoneGateDefaultScript.player_not_next_to_worker
	LD A, 2 ; SCRIPT_SAFARIZONEGATE_WOULD_YOU_LIKE_TO_JOIN
	LD ($D61F), A ; wSafariZoneGateCurScript
	RET
SafariZoneGateDefaultScript.player_not_next_to_worker:
	LD A, $10 ; PAD_RIGHT
	LD C, 1
	CALL SafariZoneEntranceAutoWalk
	LD A, $F0 ; PAD_CTRL_PAD
	LD ($CD6B), A ; wJoyIgnore
	LD A, 1 ; SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_RIGHT
	LD ($D61F), A ; wSafariZoneGateCurScript
	RET
SafariZoneGateDefaultScript.PlayerNextToSafariZoneWorker1CoordsArray:
	.DB $02,$03,$02,$04,$FF
SafariZoneGateDefaultEnd:
.ASSERT SafariZoneGateDefaultEnd - SafariZoneGateDefaultScript == 63
