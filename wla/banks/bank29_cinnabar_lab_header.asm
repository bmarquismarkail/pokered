CinnabarLab_h:
	.DB $14,$04,$09
	.DW CinnabarLab_Blocks
	.DW CinnabarLab_TextPointers
	.DW CinnabarLab_Script
	.DB $00
	.DW CinnabarLab_Object
CinnabarLabHeaderEnd:
.ASSERT CinnabarLabHeaderEnd - CinnabarLab_h == 12
