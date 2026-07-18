FuchsiaMeetingRoomSafariZoneWorker1:
	.DB $17
	.DW $45A1
	.DB $28,$50
FuchsiaMeetingRoomSafariZoneWorker2:
	.DB $17
	.DW $45E6
	.DB $28,$50
FuchsiaMeetingRoomSafariZoneWorker3:
	.DB $17
	.DW $4642
	.DB $28,$50
FuchsiaMeetingRoomTextsEnd:
.ASSERT FuchsiaMeetingRoomTextsEnd - FuchsiaMeetingRoomSafariZoneWorker1 == 15
