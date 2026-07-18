SafariZoneGate_h:
	.DB $0C,$03,$04
	.DW SafariZoneGate_Blocks
	.DW SafariZoneGate_TextPointers
	.DW SafariZoneGate_Script
	.DB $00
	.DW SafariZoneGate_Object
SafariZoneGateHeaderEnd:
.ASSERT SafariZoneGateHeaderEnd - SafariZoneGate_h == 12
