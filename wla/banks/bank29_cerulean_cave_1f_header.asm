CeruleanCave1F_h:
	.DB $11,$09,$0F
	.DW CeruleanCave1F_Blocks
	.DW CeruleanCave1F_TextPointers
	.DW CeruleanCave1F_Script
	.DB $00
	.DW CeruleanCave1F_Object
CeruleanCave1FHeaderEnd:
.ASSERT CeruleanCave1FHeaderEnd - CeruleanCave1F_h == 12
