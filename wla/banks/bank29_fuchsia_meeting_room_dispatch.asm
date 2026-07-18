FuchsiaMeetingRoom_Script:
	CALL $3C3C ; EnableAutoTextBoxDrawing
	RET
FuchsiaMeetingRoomScriptEnd:
.ASSERT FuchsiaMeetingRoomScriptEnd - FuchsiaMeetingRoom_Script == 4

FuchsiaMeetingRoom_TextPointers:
	.DW FuchsiaMeetingRoomSafariZoneWorker1
	.DW FuchsiaMeetingRoomSafariZoneWorker2
	.DW FuchsiaMeetingRoomSafariZoneWorker3
FuchsiaMeetingRoomTextPointersEnd:
.ASSERT FuchsiaMeetingRoomTextPointersEnd - FuchsiaMeetingRoom_TextPointers == 6
