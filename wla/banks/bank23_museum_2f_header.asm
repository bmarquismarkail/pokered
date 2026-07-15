; Native WLA-DX form of the Museum 2F map header.
Museum2F_h:
.DB $0A, $04, $07 ; tileset, height, width
.DW $4048          ; Museum2F_Blocks
.DW $431A          ; Museum2F_TextPointers
.DW $4317          ; Museum2F_Script
.DB $00            ; no connections
.DW $434B          ; Museum2F_Object
Museum2FHeaderEnd:
.ASSERT Museum2FHeaderEnd - Museum2F_h == 12
