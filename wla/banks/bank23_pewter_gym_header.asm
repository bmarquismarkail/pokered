; Native WLA-DX form of the Pewter Gym map header.
PewterGym_h:
.DB $07, $07, $05 ; tileset, height, width
.DW $4558          ; PewterGym_Blocks
.DW $4435          ; PewterGym_TextPointers
.DW $4387          ; PewterGym_Script
.DB $00            ; no connections
.DW $452E          ; PewterGym_Object
PewterGymHeaderEnd:
.ASSERT PewterGymHeaderEnd - PewterGym_h == 12
