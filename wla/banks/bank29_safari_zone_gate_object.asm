; Safari Zone Gate border, warps, workers, and warp-to records.
SafariZoneGate_Object:
	.DB $0A ; border block
	.DB $04 ; warp count
	.DB $05,$03,$04,$FF
	.DB $05,$04,$04,$FF
	.DB $00,$03,$00,$DC
	.DB $00,$04,$01,$DC
	.DB $00 ; background-event count
	.DB $02 ; object count
	.DB $23,$06,$0A,$FF,$D2,$01
	.DB $23,$08,$05,$FF,$D3,$02
	.DB $08,$C7,$05,$03
	.DB $09,$C7,$05,$04
	.DB $F4,$C6,$00,$03
	.DB $F5,$C6,$00,$04
SafariZoneGateObjectEnd:
.ASSERT SafariZoneGateObjectEnd - SafariZoneGate_Object == 48
