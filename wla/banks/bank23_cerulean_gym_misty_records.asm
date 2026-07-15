CeruleanGymMistyCascadeBadgeInfoText:
	.DB $17
	.DW $4AB0
	.DB $26, $50
CeruleanGymMistyReceivedTM11Text:
	.DB $17
	.DW $4B7D
	.DB $26, $0B, $50
CeruleanGymMistyTM11NoRoomText:
	.DB $17
	.DW $4B90
	.DB $26, $50
CeruleanGymMistyReceivedCascadeBadgeText:
	.DB $17
	.DW $4BB0
	.DB $26, $11, $06, $50
CeruleanGymMistyRecordsEnd:
.ASSERT CeruleanGymMistyRecordsEnd - CeruleanGymMistyCascadeBadgeInfoText == 23
