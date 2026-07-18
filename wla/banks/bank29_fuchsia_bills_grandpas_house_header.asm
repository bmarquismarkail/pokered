FuchsiaBillsGrandpasHouse_h:
	.DB $08,$04,$04
	.DW FuchsiaBillsGrandpasHouse_Blocks
	.DW FuchsiaBillsGrandpasHouse_TextPointers
	.DW FuchsiaBillsGrandpasHouse_Script
	.DB $00
	.DW FuchsiaBillsGrandpasHouse_Object
FuchsiaBillsGrandpasHouseHeaderEnd:
.ASSERT FuchsiaBillsGrandpasHouseHeaderEnd - FuchsiaBillsGrandpasHouse_h == 12
