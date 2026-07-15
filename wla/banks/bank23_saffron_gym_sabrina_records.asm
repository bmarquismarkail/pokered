SaffronGymSabrinaMarshBadgeInfoText:
	.DB $17
	.DW $5D16
	.DB $28, $50
SaffronGymSabrinaReceivedTM46Text:
	.DB $17
	.DW $5DCD
	.DB $28, $0B
	.DB $17
	.DW $5DE0
	.DB $28, $50
SaffronGymSabrinaTM46NoRoomText:
	.DB $17
	.DW $5E25
	.DB $28, $50
SaffronGymSabrinaRecordsEnd:
.ASSERT SaffronGymSabrinaRecordsEnd - SaffronGymSabrinaMarshBadgeInfoText == 20
