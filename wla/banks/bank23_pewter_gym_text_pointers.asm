; Pewter Gym text pointer table.
PewterGym_TextPointers:
.DW $444E ; PewterGymBrockText
.DW $44C6 ; PewterGymCooltrainerMText
.DW $44DF ; PewterGymGuideText
.DW $44A8 ; PewterGymBrockWaitTakeThisText
.DW $44AD ; PewterGymReceivedTM34Text
.DW $44B7 ; PewterGymTM34NoRoomText
PewterGymTextPointersEnd:
.ASSERT PewterGymTextPointersEnd - PewterGym_TextPointers == 12
