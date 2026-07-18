SafariZoneGateSafariZoneWorker1GoodHaulComeAgainText:
	.DB $17
	.DW $6860
	.DB $27,$50

SafariZoneGateSafariZoneWorker2Text:
	.DB $08 ; text_asm
	LD HL, SafariZoneGateSafariZoneWorker2Text.FirstTimeHereText
	CALL $3C49 ; PrintText
	CALL $35EC ; YesNoChoice
	LD A, ($CC26) ; wCurrentMenuItem
	AND A
	LD HL, SafariZoneGateSafariZoneWorker2Text.YoureARegularHereText
	JR NZ, SafariZoneGateSafariZoneWorker2Text.print_text
	LD HL, SafariZoneGateSafariZoneWorker2Text.SafariZoneExplanationText
SafariZoneGateSafariZoneWorker2Text.print_text:
	CALL $3C49 ; PrintText
	JP $24D7 ; TextScriptEnd
SafariZoneGateSafariZoneWorker2Text.FirstTimeHereText:
	.DB $17
	.DW $6886
	.DB $27,$50
SafariZoneGateSafariZoneWorker2Text.SafariZoneExplanationText:
	.DB $17
	.DW $68A7
	.DB $27,$50
SafariZoneGateSafariZoneWorker2Text.YoureARegularHereText:
	.DB $17
	.DW $6993
	.DB $27,$50
SafariZoneGateWorkerTextsEnd:
.ASSERT SafariZoneGateWorkerTextsEnd - SafariZoneGateSafariZoneWorker1GoodHaulComeAgainText == 48
