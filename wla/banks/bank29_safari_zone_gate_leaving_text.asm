SafariZoneGateSafariZoneWorker1LeavingEarlyText:
	.DB $17
	.DW $6814
	.DB $27,$08 ; text_far followed by text_asm
	CALL $35EC ; YesNoChoice
	LD A, ($CC26) ; wCurrentMenuItem
	AND A
	JR NZ, SafariZoneGateSafariZoneWorker1LeavingEarlyText.not_ready_to_leave
	LD HL, SafariZoneGateSafariZoneWorker1LeavingEarlyText.ReturnSafariBallsText
	CALL $3C49 ; PrintText
	XOR A
	LD ($C109), A ; wSpritePlayerStateData1FacingDirection
	LD A, $80 ; PAD_DOWN
	LD C, 3
	CALL SafariZoneEntranceAutoWalk
	LD HL, $D790
	RES 6, (HL) ; EVENT_SAFARI_GAME_OVER
	RES 7, (HL) ; EVENT_IN_SAFARI_ZONE
	LD A, 0 ; SCRIPT_SAFARIZONEGATE_DEFAULT
	LD ($CF0D), A ; wNextSafariZoneGateScript
	JR SafariZoneGateSafariZoneWorker1LeavingEarlyText.set_current_script
SafariZoneGateSafariZoneWorker1LeavingEarlyText.not_ready_to_leave:
	LD HL, SafariZoneGateSafariZoneWorker1LeavingEarlyText.GoodLuckText
	CALL $3C49 ; PrintText
	LD A, 4 ; SPRITE_FACING_UP
	LD ($C109), A ; wSpritePlayerStateData1FacingDirection
	LD A, $40 ; PAD_UP
	LD C, 1
	CALL SafariZoneEntranceAutoWalk
	LD A, 5 ; SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI
	LD ($CF0D), A ; wNextSafariZoneGateScript
SafariZoneGateSafariZoneWorker1LeavingEarlyText.set_current_script:
	LD A, 6 ; SCRIPT_SAFARIZONEGATE_SET_SCRIPT_AFTER_MOVE
	LD ($D61F), A ; wSafariZoneGateCurScript
	JP $24D7 ; TextScriptEnd

SafariZoneGateSafariZoneWorker1LeavingEarlyText.ReturnSafariBallsText:
	.DB $17
	.DW $6825
	.DB $27,$50
SafariZoneGateSafariZoneWorker1LeavingEarlyText.GoodLuckText:
	.DB $17
	.DW $6854
	.DB $27,$50
SafariZoneGateLeavingTextEnd:
.ASSERT SafariZoneGateLeavingTextEnd - SafariZoneGateSafariZoneWorker1LeavingEarlyText == 86
