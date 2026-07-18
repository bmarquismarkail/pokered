SafariZoneGate_TextPointers:
	.DW SafariZoneGateSafariZoneWorker1Text
	.DW SafariZoneGateSafariZoneWorker2Text
	.DW SafariZoneGateSafariZoneWorker1Text
	.DW SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText
	.DW SafariZoneGateSafariZoneWorker1LeavingEarlyText
	.DW SafariZoneGateSafariZoneWorker1GoodHaulComeAgainText
SafariZoneGateTextPointersEnd:
.ASSERT SafariZoneGateTextPointersEnd - SafariZoneGate_TextPointers == 12

SafariZoneGateSafariZoneWorker1Text:
	.DB $17
	.DW $66C7
	.DB $27,$50
SafariZoneGateWorker1TextEnd:
.ASSERT SafariZoneGateWorker1TextEnd - SafariZoneGateSafariZoneWorker1Text == 5
