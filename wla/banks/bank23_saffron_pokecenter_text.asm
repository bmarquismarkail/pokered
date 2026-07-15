SaffronPokecenter_TextPointers:
	.DW SaffronPokecenterNurseText
	.DW SaffronPokecenterBeautyText
	.DW SaffronPokecenterGentlemanText
	.DW SaffronPokecenterLinkReceptionistText
SaffronPokecenterTextPointersEnd:
.ASSERT SaffronPokecenterTextPointersEnd - SaffronPokecenter_TextPointers == 8
SaffronPokecenterNurseText:
	.DB $FF
SaffronPokecenterBeautyText:
	.DB $17
	.DW $648E
	.DB $28, $50
SaffronPokecenterGentlemanText:
	.DB $17
	.DW $64BF
	.DB $28, $50
SaffronPokecenterLinkReceptionistText:
	.DB $F6
SaffronPokecenterTextEnd:
.ASSERT SaffronPokecenterTextEnd - SaffronPokecenterNurseText == 12
