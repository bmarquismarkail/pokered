UndergroundPathRoute7Copy_h:
	.DB $0C, $04, $04
	.DW $4080
	.DW UndergroundPathRoute7Copy_TextPointers
	.DW UndergroundPathRoute7Copy_Script
	.DB $00
	.DW UndergroundPathRoute7Copy_Object
UndergroundPathRoute7CopyHeaderEnd:
.ASSERT UndergroundPathRoute7CopyHeaderEnd - UndergroundPathRoute7Copy_h == 12
UndergroundPathRoute7Copy_Script:
	LD A, $12 ; ROUTE_7
	LD ($D365), A
	RET
UndergroundPathRoute7CopyScriptEnd:
.ASSERT UndergroundPathRoute7CopyScriptEnd - UndergroundPathRoute7Copy_Script == 6
UndergroundPathRoute7Copy_TextPointers:
	.DW UndergroundPathRoute7CopyUnusedGirlText
	.DW UndergroundPathRoute7CopyUnusedMiddleAgedManText
UndergroundPathRoute7CopyTextPointersEnd:
.ASSERT UndergroundPathRoute7CopyTextPointersEnd - UndergroundPathRoute7Copy_TextPointers == 4
UndergroundPathRoute7CopyUnusedGirlText:
	.DB $17
	.DW $4132
	.DB $23, $50
UndergroundPathRoute7CopyUnusedTeamRocketHadAHideoutText:
	.DB $17
	.DW $4195
	.DB $23, $50
UndergroundPathRoute7CopyUnusedMiddleAgedManText:
	.DB $17
	.DW $41C8
	.DB $23, $50
UndergroundPathRoute7CopyUnusedGoesUnderSaffronText:
	.DB $17
	.DW $4209
	.DB $23, $50
UndergroundPathRoute7CopyTextEnd:
.ASSERT UndergroundPathRoute7CopyTextEnd - UndergroundPathRoute7CopyUnusedGirlText == 20
UndergroundPathRoute7Copy_Object:
	.DB $0A,$03, $07,$03,$05,$FF, $07,$04,$05,$FF, $04,$04,$00,$79
	.DB $00,$02, $0D,$06,$07,$FF,$FF,$01, $0A,$08,$06,$FF,$FF,$02
	.DB $12,$C7,$07,$03, $13,$C7,$07,$04, $09,$C7,$04,$04
UndergroundPathRoute7CopyObjectEnd:
.ASSERT UndergroundPathRoute7CopyObjectEnd - UndergroundPathRoute7Copy_Object == 40
