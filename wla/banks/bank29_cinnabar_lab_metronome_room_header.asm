CinnabarLabMetronomeRoom_h:
	.DB $14,$04,$04
	.DW CinnabarLabMetronomeRoom_Blocks
	.DW CinnabarLabMetronomeRoom_TextPointers
	.DW CinnabarLabMetronomeRoom_Script
	.DB $00
	.DW CinnabarLabMetronomeRoom_Object
CinnabarLabMetronomeRoomHeaderEnd:
.ASSERT CinnabarLabMetronomeRoomHeaderEnd - CinnabarLabMetronomeRoom_h == 12
