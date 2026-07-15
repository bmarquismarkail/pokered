; Brock's badge/TM text command records.
PewterGymBrockWaitTakeThisText:
	.DB $17
	.DW $4092 ; _PewterGymBrockWaitTakeThisText
	.DB $26, $50
PewterGymReceivedTM34Text:
	.DB $17
	.DW $40AD ; _PewterGymReceivedTM34Text
	.DB $26
	.DB $0B ; sound_get_item_1
	.DB $17
	.DW $40C0 ; _TM34ExplanationText
	.DB $26, $50
PewterGymTM34NoRoomText:
	.DB $17
	.DW $41AB ; _PewterGymTM34NoRoomText
	.DB $26, $50
PewterGymBrockReceivedBoulderBadgeText:
	.DB $17
	.DW $41C9 ; _PewterGymBrockReceivedBoulderBadgeText
	.DB $26
	.DB $0B ; sound_level_up
	.DB $17
	.DW $4232 ; _PewterGymBrockBoulderBadgeInfoText
	.DB $26, $50
PewterGymBrockTextRecordsEnd:
.ASSERT PewterGymBrockTextRecordsEnd - PewterGymBrockWaitTakeThisText == 30
