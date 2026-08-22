MtMoonB1F_Object:
	.DB $3 ; border block

	.DB 8
	warp_event  5,  5, MT_MOON_1F, 3
	warp_event 17, 11, MT_MOON_B2F, 1
	warp_event 25,  9, MT_MOON_1F, 4
	warp_event 25, 15, MT_MOON_1F, 5
	warp_event 21, 17, MT_MOON_B2F, 2
	warp_event 13, 27, MT_MOON_B2F, 3
	warp_event 23,  3, MT_MOON_B2F, 4
	warp_event 27,  3, LAST_MAP, 3

	.DB 0
	.DB 0
	event_displacement MT_MOON_B1F_WIDTH, 5, 5
	event_displacement MT_MOON_B1F_WIDTH, 17, 11
	event_displacement MT_MOON_B1F_WIDTH, 25, 9
	event_displacement MT_MOON_B1F_WIDTH, 25, 15
	event_displacement MT_MOON_B1F_WIDTH, 21, 17
	event_displacement MT_MOON_B1F_WIDTH, 13, 27
	event_displacement MT_MOON_B1F_WIDTH, 23, 3
	event_displacement MT_MOON_B1F_WIDTH, 27, 3