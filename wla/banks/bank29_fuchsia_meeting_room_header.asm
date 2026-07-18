FuchsiaMeetingRoom_h:
	.DB $14,$04,$07
	.DW FuchsiaMeetingRoom_Blocks
	.DW FuchsiaMeetingRoom_TextPointers
	.DW FuchsiaMeetingRoom_Script
	.DB $00
	.DW FuchsiaMeetingRoom_Object
FuchsiaMeetingRoomHeaderEnd:
.ASSERT FuchsiaMeetingRoomHeaderEnd - FuchsiaMeetingRoom_h == 12
