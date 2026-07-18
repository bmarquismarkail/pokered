SafariZoneGate_h:
	.DB $0C,$03,$04
	.DW $5425 ; SafariZoneGate_Blocks
	.DW $52B9 ; SafariZoneGate_TextPointers
	.DW SafariZoneGate_Script
	.DB $00
	.DW $53F5 ; SafariZoneGate_Object
SafariZoneGateHeaderEnd:
.ASSERT SafariZoneGateHeaderEnd - SafariZoneGate_h == 12
