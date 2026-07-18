CeruleanBadgeHouse_h:
	.DB $0D,$04,$04
	.DW CeruleanBadgeHouse_Blocks
	.DW CeruleanBadgeHouse_TextPointers
	.DW CeruleanBadgeHouse_Script
	.DB $00
	.DW CeruleanBadgeHouse_Object
CeruleanBadgeHouseHeaderEnd:
.ASSERT CeruleanBadgeHouseHeaderEnd - CeruleanBadgeHouse_h == 12
