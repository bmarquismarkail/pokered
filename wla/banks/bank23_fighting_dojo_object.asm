FightingDojo_Object:
.DB $03, $02
.DB $0B, $04, $01, $FF
.DB $0B, $05, $01, $FF
.DB $00, $07
.DB $0E, $07, $09, $FF, $D0, $41, $E0, $01
.DB $0E, $08, $07, $FF, $D3, $42, $E0, $02
.DB $0E, $0A, $07, $FF, $D3, $43, $E0, $03
.DB $0E, $09, $09, $FF, $D2, $44, $E0, $04
.DB $0E, $0B, $09, $FF, $D2, $45, $E0, $05
.DB $3D, $05, $08, $FF, $FF, $06
.DB $3D, $05, $09, $FF, $FF, $07
.DB $2D, $C7, $0B, $04
.DB $2D, $C7, $0B, $05
FightingDojoObjectEnd:
.ASSERT FightingDojoObjectEnd - FightingDojo_Object == 72
