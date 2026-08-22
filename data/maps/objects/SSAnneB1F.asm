SSAnneB1F_Object:
	.DB $c ; border block

	.DB 6
	warp_event 23,  3, SS_ANNE_B1F_ROOMS, 9
	warp_event 19,  3, SS_ANNE_B1F_ROOMS, 7
	warp_event 15,  3, SS_ANNE_B1F_ROOMS, 5
	warp_event 11,  3, SS_ANNE_B1F_ROOMS, 3
	warp_event  7,  3, SS_ANNE_B1F_ROOMS, 1
	warp_event 27,  5, SS_ANNE_1F, 10

	.DB 0
	.DB 0
	event_displacement SS_ANNE_B1F_WIDTH, 23, 3
	event_displacement SS_ANNE_B1F_WIDTH, 19, 3
	event_displacement SS_ANNE_B1F_WIDTH, 15, 3
	event_displacement SS_ANNE_B1F_WIDTH, 11, 3
	event_displacement SS_ANNE_B1F_WIDTH, 7, 3
	event_displacement SS_ANNE_B1F_WIDTH, 27, 5