; Native WLA-DX form of the Pewter Pokecenter map header.
PewterPokecenter_h:
.DB $06, $04, $07 ; tileset, height, width
.DW $4064          ; PewterPokecenter_Blocks
.DW $458D          ; PewterPokecenter_TextPointers
.DW $4587          ; PewterPokecenter_Script
.DB $00            ; no connections
.DW $460D          ; PewterPokecenter_Object
PewterPokecenterHeaderEnd:
.ASSERT PewterPokecenterHeaderEnd - PewterPokecenter_h == 12
