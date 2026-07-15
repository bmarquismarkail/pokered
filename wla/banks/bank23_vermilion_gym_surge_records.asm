VermilionGymLTSurgeThunderBadgeInfoText:
	.DB $17
	.DW $4069
	.DB $27, $50
VermilionGymLTSurgeReceivedTM24Text:
	.DB $17
	.DW $40E0
	.DB $27, $11
	.DB $17
	.DW $40F5
	.DB $27, $50
VermilionGymLTSurgeTM24NoRoomText:
	.DB $17
	.DW $4130
	.DB $27, $50
VermilionGymLTSurgeReceivedThunderBadgeText:
	.DB $17
	.DW $4151
	.DB $27, $50
VermilionGymSurgeRecordsEnd:
.ASSERT VermilionGymSurgeRecordsEnd - VermilionGymLTSurgeThunderBadgeInfoText == 25
