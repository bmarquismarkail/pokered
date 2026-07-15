; Pewter Pokecenter border, warps, objects, and warp-to records.
PewterPokecenter_Object:
.DB $00                         ; border block
.DB $02                         ; warp count
.DB $07, $03, $06, $FF
.DB $07, $04, $06, $FF
.DB $00                         ; background-event count
.DB $04                         ; object count
.DB $29, $05, $07, $FF, $D0, $01
.DB $10, $0B, $0F, $FF, $D2, $02
.DB $38, $07, $05, $FF, $D0, $03
.DB $2A, $06, $0F, $FF, $D0, $04
.DB $1E, $C7, $07, $03
.DB $1F, $C7, $07, $04
PewterPokecenterObjectEnd:
.ASSERT PewterPokecenterObjectEnd - PewterPokecenter_Object == 44
