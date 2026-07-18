SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText:
	.DB $17
	.DW $66E4
	.DB $27,$08 ; text_far followed by text_asm
	LD A, $13 ; MONEY_BOX
	LD ($D125), A ; wTextBoxID
	CALL $30E8 ; DisplayTextBoxID
	CALL $35EC ; YesNoChoice
	LD A, ($CC26) ; wCurrentMenuItem
	AND A
	JP NZ, SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.PleaseComeAgain
	XOR A
	LDH ($9F), A ; hMoney
	LD A, $05
	LDH ($A0), A
	LD A, $00
	LDH ($A1), A
	CALL $35A6 ; HasEnoughMoney
	JR NC, SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.success
	LD HL, SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.NotEnoughMoneyText
	CALL $3C49 ; PrintText
	JR SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.CantPayWalkDown
SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.success:
	XOR A
	LD ($CD3D), A ; wPriceTemp
	LD A, $05
	LD ($CD3E), A
	LD A, $00
	LD ($CD3F), A
	LD HL, $CD3F ; wPriceTemp + 2
	LD DE, $D349 ; wPlayerMoney + 2
	LD C, 3
	LD A, $0C ; SubBCDPredef
	CALL $3E6D ; Predef
	LD A, $13 ; MONEY_BOX
	LD ($D125), A ; wTextBoxID
	CALL $30E8 ; DisplayTextBoxID
	LD HL, SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.MakePaymentText
	CALL $3C49 ; PrintText
	LD A, 30
	LD ($DA47), A ; wNumSafariBalls
	LD A, $01
	LD ($D70D), A ; wSafariSteps
	LD A, $F6
	LD ($D70E), A
	LD A, $40 ; PAD_UP
	LD C, 3
	CALL SafariZoneEntranceAutoWalk
	LD HL, $D790
	SET 7, (HL) ; EVENT_IN_SAFARI_ZONE
	RES 6, (HL) ; EVENT_SAFARI_GAME_OVER
	LD A, 3 ; SCRIPT_SAFARIZONEGATE_PLAYER_MOVING
	LD ($D61F), A ; wSafariZoneGateCurScript
	JR SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.done
SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.PleaseComeAgain:
	LD HL, SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.PleaseComeAgainText
	CALL $3C49 ; PrintText
SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.CantPayWalkDown:
	LD A, $80 ; PAD_DOWN
	LD C, 1
	CALL SafariZoneEntranceAutoWalk
	LD A, 4 ; SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_DOWN
	LD ($D61F), A ; wSafariZoneGateCurScript
SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.done:
	JP $24D7 ; TextScriptEnd

SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.MakePaymentText:
	.DB $17
	.DW $6747
	.DB $27,$0B
	.DB $17
	.DW $679F
	.DB $27,$50
SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.PleaseComeAgainText:
	.DB $17
	.DW $67E3
	.DB $27,$50
SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText.NotEnoughMoneyText:
	.DB $17
	.DW $67FB
	.DB $27,$50
SafariZoneGateAdmissionTextEnd:
.ASSERT SafariZoneGateAdmissionTextEnd - SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText == 165
