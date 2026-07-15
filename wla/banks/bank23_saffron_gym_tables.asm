SaffronGym_TextPointers:
.DW $5118, $5187, $5191, $519B, $51A5, $51AF, $51B9, $51C3
.DW $51CD, $5173, $5178, $5182
SaffronGymTextPointersEnd:
.ASSERT SaffronGymTextPointersEnd - SaffronGym_TextPointers == 24

SaffronGymTrainerHeaders:
SaffronGymTrainerHeader0:
.DB $02, $30, $B3, $D7
.DW $51F0, $51FA, $51F5, $51F5
SaffronGymTrainerHeader1:
.DB $03, $30, $B3, $D7
.DW $51FF, $5209, $5204, $5204
SaffronGymTrainerHeader2:
.DB $04, $30, $B3, $D7
.DW $520E, $5218, $5213, $5213
SaffronGymTrainerHeader3:
.DB $05, $30, $B3, $D7
.DW $521D, $5227, $5222, $5222
SaffronGymTrainerHeader4:
.DB $06, $30, $B3, $D7
.DW $522C, $5236, $5231, $5231
SaffronGymTrainerHeader5:
.DB $07, $30, $B3, $D7
.DW $523B, $5245, $5240, $5240
SaffronGymTrainerHeader6:
.DB $08, $30, $B3, $D7
.DW $524A, $5254, $524F, $524F
.DB $FF
SaffronGymTrainerHeadersEnd:
.ASSERT SaffronGymTrainerHeadersEnd - SaffronGymTrainerHeaders == 85
