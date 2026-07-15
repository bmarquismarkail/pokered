; Pewter Gym border, warps, objects, and warp-to records.
PewterGym_Object:
.DB $03                         ; border block
.DB $02                         ; warp count
.DB $0D, $04, $02, $FF         ; warp 1
.DB $0D, $05, $02, $FF         ; warp 2
.DB $00                         ; background-event count
.DB $03                         ; object count
.DB $0C, $05, $08, $FF, $D0, $41, $EA, $01
.DB $07, $0A, $07, $FF, $D3, $42, $CD, $01
.DB $24, $0E, $0B, $FF, $D0, $03
.DB $38, $C7, $0D, $04         ; warp-to 1
.DB $38, $C7, $0D, $05         ; warp-to 2
PewterGymObjectEnd:
.ASSERT PewterGymObjectEnd - PewterGym_Object == 42
