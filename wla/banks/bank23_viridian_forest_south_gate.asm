ViridianForestSouthGate_h:
	.DB $09, $04, $05
	.DW $4090
	.DW ViridianForestSouthGate_TextPointers
	.DW ViridianForestSouthGate_Script
	.DB $00
	.DW ViridianForestSouthGate_Object
ViridianForestSouthGateHeaderEnd:
.ASSERT ViridianForestSouthGateHeaderEnd - ViridianForestSouthGate_h == 12
ViridianForestSouthGate_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
ViridianForestSouthGateScriptEnd:
.ASSERT ViridianForestSouthGateScriptEnd - ViridianForestSouthGate_Script == 3
ViridianForestSouthGate_TextPointers:
	.DW ViridianForestSouthGateGirlText
	.DW ViridianForestSouthGateLittleGirlText
ViridianForestSouthGateTextPointersEnd:
.ASSERT ViridianForestSouthGateTextPointersEnd - ViridianForestSouthGate_TextPointers == 4
ViridianForestSouthGateGirlText:
	.DB $17
	.DW $6868
	.DB $22, $50
ViridianForestSouthGateLittleGirlText:
	.DB $17
	.DW $68AB
	.DB $22, $50
ViridianForestSouthGateTextEnd:
.ASSERT ViridianForestSouthGateTextEnd - ViridianForestSouthGateGirlText == 10
; Object layout translated from data/maps/objects/ViridianForestSouthGate.asm.
ViridianForestSouthGate_Object:
	.DB $0A, $04
	.DB $00,$04,$03,$33
	.DB $00,$05,$04,$33
	.DB $07,$04,$05,$FF
	.DB $07,$05,$05,$FF
	.DB $00, $02
	.DB $0D,$08,$0C,$FF,$D2,$01
	.DB $08,$08,$06,$FE,$01,$02
	.DB $F6,$C6,$00,$04
	.DB $F6,$C6,$00,$05
	.DB $17,$C7,$07,$04
	.DB $17,$C7,$07,$05
ViridianForestSouthGateObjectEnd:
.ASSERT ViridianForestSouthGateObjectEnd - ViridianForestSouthGate_Object == 48
