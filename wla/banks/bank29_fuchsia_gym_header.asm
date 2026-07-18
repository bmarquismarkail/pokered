FuchsiaGym_h:
	.DB $07,$09,$05
	.DW FuchsiaGym_Blocks
	.DW FuchsiaGym_TextPointers
	.DW FuchsiaGym_Script
	.DB $00
	.DW FuchsiaGym_Object
FuchsiaGymHeaderEnd:
.ASSERT FuchsiaGymHeaderEnd - FuchsiaGym_h == 12
