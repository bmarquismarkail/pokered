CeruleanGym_h:
.DB $07, $07, $05
.DW $4866 ; CeruleanGym_Blocks
.DW $474A ; CeruleanGym_TextPointers
.DW $46B3 ; CeruleanGym_Script
.DB $00
.DW $4834 ; CeruleanGym_Object
CeruleanGymHeaderEnd:
.ASSERT CeruleanGymHeaderEnd - CeruleanGym_h == 12
