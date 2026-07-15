ViridianForestNorthGate_h:
	.DB $09, $04, $05
	.DW $4090
	.DW ViridianForestNorthGate_TextPointers
	.DW ViridianForestNorthGate_Script
	.DB $00
	.DW ViridianForestNorthGate_Object
ViridianForestNorthGateHeaderEnd:
.ASSERT ViridianForestNorthGateHeaderEnd - ViridianForestNorthGate_h == 12
ViridianForestNorthGate_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
ViridianForestNorthGateScriptEnd:
.ASSERT ViridianForestNorthGateScriptEnd - ViridianForestNorthGate_Script == 3
ViridianForestNorthGate_TextPointers:
	.DW ViridianForestNorthGateSuperNerdText
	.DW ViridianForestNorthGateGrampsText
ViridianForestNorthGateTextPointersEnd:
.ASSERT ViridianForestNorthGateTextPointersEnd - ViridianForestNorthGate_TextPointers == 4
ViridianForestNorthGateSuperNerdText:
	.DB $17
	.DW $66FD
	.DB $22, $50
ViridianForestNorthGateGrampsText:
	.DB $17
	.DW $675D
	.DB $22, $50
ViridianForestNorthGateTextEnd:
.ASSERT ViridianForestNorthGateTextEnd - ViridianForestNorthGateSuperNerdText == 10
; Object layout translated from data/maps/objects/ViridianForestNorthGate.asm.
ViridianForestNorthGate_Object:
	.DB $0A, $04
	.DB $00,$04,$01,$FF
	.DB $00,$05,$01,$FF
	.DB $07,$04,$00,$33
	.DB $07,$05,$00,$33
	.DB $00, $02
	.DB $0C,$06,$07,$FF,$FF,$01
	.DB $25,$09,$06,$FF,$FF,$02
	.DB $F6,$C6,$00,$04
	.DB $F6,$C6,$00,$05
	.DB $17,$C7,$07,$04
	.DB $17,$C7,$07,$05
ViridianForestNorthGateObjectEnd:
.ASSERT ViridianForestNorthGateObjectEnd - ViridianForestNorthGate_Object == 48
