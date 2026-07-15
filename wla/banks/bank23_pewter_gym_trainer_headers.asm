; Pewter Gym trainer header list.
PewterGymTrainerHeaders:
.DB $02 ; two bytes per trainer event flag
PewterGymTrainerHeader0:
.DB $50, $55, $D7 ; flag mask, event flag address
.DW $44D0          ; PewterGymCooltrainerMBattleText
.DW $44DA          ; PewterGymCooltrainerMEndBattleText
.DW $44D5          ; PewterGymCooltrainerMAfterBattleText
.DW $44D5          ; PewterGymCooltrainerMAfterBattleText
.DB $FF            ; end
PewterGymTrainerHeadersEnd:
.ASSERT PewterGymTrainerHeadersEnd - PewterGymTrainerHeaders == 13
