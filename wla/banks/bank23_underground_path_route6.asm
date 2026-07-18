UndergroundPathRoute6_h:
	.DB $0C, $04, $04
	.DW $4080
	.DW UndergroundPathRoute6_TextPointers
	.DW UndergroundPathRoute6_Script
	.DB $00
	.DW UndergroundPathRoute6_Object
UndergroundPathRoute6HeaderEnd:
.ASSERT UndergroundPathRoute6HeaderEnd - UndergroundPathRoute6_h == 12
UndergroundPathRoute6_Script:
	LD A, $11 ; ROUTE_6
	LD ($D365), A
	JP $3C3C ; EnableAutoTextBoxDrawing
UndergroundPathRoute6ScriptEnd:
.ASSERT UndergroundPathRoute6ScriptEnd - UndergroundPathRoute6_Script == 8
UndergroundPathRoute6_TextPointers:
	.DW UndergroundPathRoute6GirlText
UndergroundPathRoute6TextPointersEnd:
.ASSERT UndergroundPathRoute6TextPointersEnd - UndergroundPathRoute6_TextPointers == 2
UndergroundPathRoute6GirlText:
	.DB $17
	.DW $40CB
	.DB $23, $50
UndergroundPathRoute6TextEnd:
.ASSERT UndergroundPathRoute6TextEnd - UndergroundPathRoute6GirlText == 5
UndergroundPathRoute6_Object:
	.DB $0A,$03, $07,$03,$03,$FF, $07,$04,$03,$FF, $04,$04,$01,$77
	.DB $00,$01, $0D,$07,$06,$FF,$FF,$01
	.DB $12,$C7,$07,$03, $13,$C7,$07,$04, $09,$C7,$04,$04
UndergroundPathRoute6ObjectEnd:
.ASSERT UndergroundPathRoute6ObjectEnd - UndergroundPathRoute6_Object == 34
