CinnabarLab_Script:
	CALL $3C3C ; EnableAutoTextBoxDrawing
	RET
CinnabarLabScriptEnd:
.ASSERT CinnabarLabScriptEnd - CinnabarLab_Script == 4

CinnabarLab_TextPointers:
	.DW CinnabarLabFishingGuruText,CinnabarLabPhotoText,CinnabarLabMeetingRoomSignText
	.DW CinnabarLabRAndDSignText,CinnabarLabTestingRoomSignText
CinnabarLabTextPointersEnd:
.ASSERT CinnabarLabTextPointersEnd - CinnabarLab_TextPointers == 10

CinnabarLabFishingGuruText:
	.DB $17
	.DW $4DF7
	.DB $28,$50
CinnabarLabPhotoText:
	.DB $17
	.DW $4E49
	.DB $28,$50
CinnabarLabMeetingRoomSignText:
	.DB $17
	.DW $4E70
	.DB $28,$50
CinnabarLabRAndDSignText:
	.DB $17
	.DW $4E87
	.DB $28,$50
CinnabarLabTestingRoomSignText:
	.DB $17
	.DW $4E9E
	.DB $28,$50
CinnabarLabTextsEnd:
.ASSERT CinnabarLabTextsEnd - CinnabarLabFishingGuruText == 25
