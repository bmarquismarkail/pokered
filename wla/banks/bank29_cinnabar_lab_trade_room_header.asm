CinnabarLabTradeRoom_h:
	.DB $14,$04,$04
	.DW CinnabarLabTradeRoom_Blocks
	.DW CinnabarLabTradeRoom_TextPointers
	.DW CinnabarLabTradeRoom_Script
	.DB $00
	.DW CinnabarLabTradeRoom_Object
CinnabarLabTradeRoomHeaderEnd:
.ASSERT CinnabarLabTradeRoomHeaderEnd - CinnabarLabTradeRoom_h == 12
