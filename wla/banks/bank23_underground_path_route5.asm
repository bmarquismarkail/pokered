UndergroundPathRoute5_h:
	.DB $0C, $04, $04
	.DW $4080
	.DW UndergroundPathRoute5_TextPointers
	.DW UndergroundPathRoute5_Script
	.DB $00
	.DW UndergroundPathRoute5_Object
UndergroundPathRoute5HeaderEnd:
.ASSERT UndergroundPathRoute5HeaderEnd - UndergroundPathRoute5_h == 12
UndergroundPathRoute5_Script:
	LD A, $10 ; ROUTE_5
	LD ($D365), A ; wLastMap
	RET
UndergroundPathRoute5ScriptEnd:
.ASSERT UndergroundPathRoute5ScriptEnd - UndergroundPathRoute5_Script == 6
UndergroundPathEntranceRoute5_TextScriptEndingText:
	.DB $50
UndergroundPathRoute5_TextPointers:
	.DW UndergroundPathRoute5LittleGirlText
UndergroundPathRoute5TextPointersEnd:
.ASSERT UndergroundPathRoute5TextPointersEnd - UndergroundPathRoute5_TextPointers == 2
UndergroundPathRoute5LittleGirlText:
	.DB $08
	LD A, $09 ; TRADE_FOR_SPOT
	LD ($CD3D), A ; wWhichTrade
	LD A, $54 ; DoInGameTradeDialogue predef
	CALL $3E6D
	LD HL, UndergroundPathEntranceRoute5_TextScriptEndingText
	RET
UndergroundPathRoute5TextEnd:
.ASSERT UndergroundPathRoute5TextEnd - UndergroundPathRoute5LittleGirlText == 15
; Object layout translated from data/maps/objects/UndergroundPathRoute5.asm.
UndergroundPathRoute5_Object:
	.DB $0A, $03
	.DB $07,$03,$03,$FF
	.DB $07,$04,$03,$FF
	.DB $04,$04,$00,$77
	.DB $00, $01
	.DB $08,$07,$06,$FF,$FF,$01
	.DB $12,$C7,$07,$03
	.DB $13,$C7,$07,$04
	.DB $09,$C7,$04,$04
UndergroundPathRoute5ObjectEnd:
.ASSERT UndergroundPathRoute5ObjectEnd - UndergroundPathRoute5_Object == 34
