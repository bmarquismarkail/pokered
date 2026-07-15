VermilionGym_Object:
.DB $03, $02
.DB $11, $04, $03, $FF
.DB $11, $05, $03, $FF
.DB $00, $05
.DB $21, $05, $09, $FF, $D0, $41, $EC, $01
.DB $10, $0A, $0D, $FF, $D2, $42, $F1, $03
.DB $0C, $0C, $07, $FF, $D2, $43, $DC, $01
.DB $13, $0E, $04, $FF, $D3, $44, $CC, $08
.DB $24, $12, $08, $FF, $D0, $05
.DB $4E, $C7, $11, $04
.DB $4E, $C7, $11, $05
VermilionGymObjectEnd:
.ASSERT VermilionGymObjectEnd - VermilionGym_Object == 58
