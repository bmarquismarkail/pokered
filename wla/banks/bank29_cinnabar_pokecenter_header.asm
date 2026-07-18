CinnabarPokecenter_h:
	.DB $06,$04,$07
	.DW CinnabarPokecenter_Blocks
	.DW CinnabarPokecenter_TextPointers
	.DW CinnabarPokecenter_Script
	.DB $00
	.DW CinnabarPokecenter_Object
CinnabarPokecenterHeaderEnd:
.ASSERT CinnabarPokecenterHeaderEnd - CinnabarPokecenter_h == 12
