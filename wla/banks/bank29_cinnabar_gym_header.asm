CinnabarGym_h:
	.DB $16,$09,$0A
	.DW $5B26 ; CinnabarGym_Blocks
	.DW CinnabarGym_TextPointers
	.DW CinnabarGym_Script
	.DB $00
	.DW $5ACC ; CinnabarGym_Object
CinnabarGymHeaderEnd:
.ASSERT CinnabarGymHeaderEnd - CinnabarGym_h == 12
