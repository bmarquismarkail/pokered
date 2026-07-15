; Pewter Gym trainer header list.
PewterGymTrainerHeaders:
PewterGymTrainerHeader0:
.DB $02, $50, $55, $D7 ; flag bit, flag mask, event flag address
.DW $44D0          ; PewterGymCooltrainerMBattleText
.DW $44DA          ; PewterGymCooltrainerMEndBattleText
.DW $44D5          ; PewterGymCooltrainerMAfterBattleText
.DW $44D5          ; PewterGymCooltrainerMAfterBattleText
.DB $FF            ; end
PewterGymTrainerHeadersEnd:
.ASSERT PewterGymTrainerHeadersEnd - PewterGymTrainerHeaders == 13
