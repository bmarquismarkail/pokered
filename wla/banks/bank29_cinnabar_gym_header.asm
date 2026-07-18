CinnabarGym_h:
	.DB $16,$09,$0A
	.DW CinnabarGym_Blocks
	.DW CinnabarGym_TextPointers
	.DW CinnabarGym_Script
	.DB $00
	.DW CinnabarGym_Object
CinnabarGymHeaderEnd:
.ASSERT CinnabarGymHeaderEnd - CinnabarGym_h == 12
