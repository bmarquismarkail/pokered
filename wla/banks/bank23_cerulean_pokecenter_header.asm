CeruleanPokecenter_h:
.DB $06, $04, $07
.DW $468B ; CeruleanPokecenter_Blocks
.DW $464B ; CeruleanPokecenter_TextPointers
.DW $4645 ; CeruleanPokecenter_Script
.DB $00
.DW $465F ; CeruleanPokecenter_Object
CeruleanPokecenterHeaderEnd:
.ASSERT CeruleanPokecenterHeaderEnd - CeruleanPokecenter_h == 12
