CopycatsHouse2F_Object:
.DB $0A, $01
.DB $01, $07, $02, $AF
.DB $02
.DB $05, $03, $06
.DB $01, $00, $07
.DB $05
.DB $1D, $07, $08, $FE, $00, $01
.DB $09, $0A, $08, $FE, $02, $02
.DB $05, $05, $09, $FF, $D0, $03
.DB $09, $04, $06, $FF, $D0, $04
.DB $38, $0A, $05, $FF, $D3, $05
.DB $F6, $C6, $01, $07
CopycatsHouse2FObjectEnd:
.ASSERT CopycatsHouse2FObjectEnd - CopycatsHouse2F_Object == 48
