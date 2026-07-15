SilphCo1F_TextPointers:
	.DW SilphCo1FLinkReceptionistText
SilphCo1FTextPointersEnd:
.ASSERT SilphCo1FTextPointersEnd - SilphCo1F_TextPointers == 2
SilphCo1FLinkReceptionistText:
	.DB $17
	.DW $645A
	.DB $28, $50
SilphCo1FTextEnd:
.ASSERT SilphCo1FTextEnd - SilphCo1FLinkReceptionistText == 5
