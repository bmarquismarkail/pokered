FightingDojo_TextPointers:
.DW $4E44, $4EA2, $4EBB, $4ED4, $4EED, $4F06, $4F4E, $4E98
FightingDojoTextPointersEnd:
.ASSERT FightingDojoTextPointersEnd - FightingDojo_TextPointers == 16

FightingDojoTrainerHeaders:
FightingDojoTrainerHeader0:
.DB $02, $40, $B1, $D7
.DW $4EAC, $4EB6, $4EB1, $4EB1
FightingDojoTrainerHeader1:
.DB $03, $40, $B1, $D7
.DW $4EC5, $4ECF, $4ECA, $4ECA
FightingDojoTrainerHeader2:
.DB $04, $30, $B1, $D7
.DW $4EDE, $4EE8, $4EE3, $4EE3
FightingDojoTrainerHeader3:
.DB $05, $30, $B1, $D7
.DW $4EF7, $4F01, $4EFC, $4EFC
.DB $FF
FightingDojoTrainerHeadersEnd:
.ASSERT FightingDojoTrainerHeadersEnd - FightingDojoTrainerHeaders == 49
