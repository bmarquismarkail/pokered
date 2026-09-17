IndigoPlateau_Object:
	.DB $e ; border block

	.DB 2
	warp_event  9,  5, INDIGO_PLATEAU_LOBBY, 1
	warp_event 10,  5, INDIGO_PLATEAU_LOBBY, 1

	.DB 0
	.DB 0
	event_displacement INDIGO_PLATEAU_WIDTH, 9, 5
	event_displacement INDIGO_PLATEAU_WIDTH, 10, 5