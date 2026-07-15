CeruleanMart_h:
.DB $02, $04, $04
.DW $4000 ; CeruleanMart_Blocks
.DW $4898 ; CeruleanMart_TextPointers
.DW $4895 ; CeruleanMart_Script
.DB $00
.DW $48A8 ; CeruleanMart_Object
CeruleanMartHeaderEnd:
.ASSERT CeruleanMartHeaderEnd - CeruleanMart_h == 12
