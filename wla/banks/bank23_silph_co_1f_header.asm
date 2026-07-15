SilphCo1F_h:
	.DB $16, $09, $0F
	.DW SilphCo1F_Blocks
	.DW SilphCo1F_TextPointers
	.DW SilphCo1F_Script
	.DB $00
	.DW SilphCo1F_Object
SilphCo1FHeaderEnd:
.ASSERT SilphCo1FHeaderEnd - SilphCo1F_h == 12
