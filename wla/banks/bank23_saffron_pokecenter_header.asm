SaffronPokecenter_h:
	.DB $06, $04, $07
	.DW $4064
	.DW SaffronPokecenter_TextPointers
	.DW SaffronPokecenter_Script
	.DB $00
	.DW SaffronPokecenter_Object
SaffronPokecenterHeaderEnd:
.ASSERT SaffronPokecenterHeaderEnd - SaffronPokecenter_h == 12
