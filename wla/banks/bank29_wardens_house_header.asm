WardensHouse_h:
	.DB $14,$04,$05
	.DW WardensHouse_Blocks
	.DW WardensHouse_TextPointers
	.DW WardensHouse_Script
	.DB $00
	.DW WardensHouse_Object
WardensHouseHeaderEnd:
.ASSERT WardensHouseHeaderEnd - WardensHouse_h == 12
