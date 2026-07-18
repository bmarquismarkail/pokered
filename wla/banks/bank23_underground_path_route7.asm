UndergroundPathRoute7_h:
	.DB $0C, $04, $04
	.DW $4080
	.DW UndergroundPathRoute7_TextPointers
	.DW UndergroundPathRoute7_Script
	.DB $00
	.DW UndergroundPathRoute7_Object
UndergroundPathRoute7HeaderEnd:
.ASSERT UndergroundPathRoute7HeaderEnd - UndergroundPathRoute7_h == 12
UndergroundPathRoute7_Script:
	LD A, $12 ; ROUTE_7
	LD ($D365), A
	JP $3C3C ; EnableAutoTextBoxDrawing
UndergroundPathRoute7ScriptEnd:
.ASSERT UndergroundPathRoute7ScriptEnd - UndergroundPathRoute7_Script == 8
UndergroundPathRoute7_TextPointers:
	.DW UndergroundPathRoute7MiddleAgedManText
UndergroundPathRoute7TextPointersEnd:
.ASSERT UndergroundPathRoute7TextPointersEnd - UndergroundPathRoute7_TextPointers == 2
UndergroundPathRoute7MiddleAgedManText:
	.DB $17
	.DW $40FF
	.DB $23, $50
UndergroundPathRoute7TextEnd:
.ASSERT UndergroundPathRoute7TextEnd - UndergroundPathRoute7MiddleAgedManText == 5
UndergroundPathRoute7_Object:
	.DB $0A,$03, $07,$03,$04,$FF, $07,$04,$04,$FF, $04,$04,$00,$79
	.DB $00,$01, $0A,$08,$06,$FF,$FF,$01
	.DB $12,$C7,$07,$03, $13,$C7,$07,$04, $09,$C7,$04,$04
UndergroundPathRoute7ObjectEnd:
.ASSERT UndergroundPathRoute7ObjectEnd - UndergroundPathRoute7_Object == 34
