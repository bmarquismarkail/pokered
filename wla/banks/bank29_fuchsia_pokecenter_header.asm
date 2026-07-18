FuchsiaPokecenter_h:
	.DB $06,$04,$07
	.DW FuchsiaPokecenter_Blocks
	.DW FuchsiaPokecenter_TextPointers
	.DW FuchsiaPokecenter_Script
	.DB $00
	.DW FuchsiaPokecenter_Object
FuchsiaPokecenterHeaderEnd:
.ASSERT FuchsiaPokecenterHeaderEnd - FuchsiaPokecenter_h == 12
