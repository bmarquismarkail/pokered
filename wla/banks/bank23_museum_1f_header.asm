; Native WLA-DX form of the Museum 1F map header.
Museum1F_h:
.DB $0A, $04, $0A ; tileset, height, width
.DW $4020          ; Museum1F_Blocks
.DW $412B          ; Museum1F_TextPointers
.DW $40F7          ; Museum1F_Script
.DB $00            ; no connections
.DW $42C1          ; Museum1F_Object
Museum1FHeaderEnd:
.ASSERT Museum1FHeaderEnd - Museum1F_h == 12
