RedsHouse2F_Object:
	.DB $a ; border block

	.DB 1
	warp_event  7,  1, REDS_HOUSE_1F, 3

	.DB 0
	.DB 0
	event_displacement REDS_HOUSE_2F_WIDTH, 7, 1