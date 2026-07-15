VermilionGym_TextPointers:
.DW $4B1D, $4B90, $4BA9, $4BC2, $4BDB, $4B77, $4B7C, $4B86
VermilionGymTextPointersEnd:
.ASSERT VermilionGymTextPointersEnd - VermilionGym_TextPointers == 16

VermilionGymTrainerHeaders:
VermilionGymTrainerHeader0:
.DB $02, $30, $73, $D7
.DW $4B9A, $4BA4, $4B9F, $4B9F
VermilionGymTrainerHeader1:
.DB $03, $20, $73, $D7
.DW $4BB3, $4BBD, $4BB8, $4BB8
VermilionGymTrainerHeader2:
.DB $04, $30, $73, $D7
.DW $4BCC, $4BD6, $4BD1, $4BD1
.DB $FF
VermilionGymTrainerHeadersEnd:
.ASSERT VermilionGymTrainerHeadersEnd - VermilionGymTrainerHeaders == 37
