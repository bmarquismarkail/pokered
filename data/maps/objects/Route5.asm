Route5_Object:
	.DB $a ; border block

	.DB 5
	warp_event 10, 29, ROUTE_5_GATE, 4
	warp_event  9, 29, ROUTE_5_GATE, 3
	warp_event 10, 33, ROUTE_5_GATE, 1
	warp_event 17, 27, UNDERGROUND_PATH_ROUTE_5, 1
	warp_event 10, 21, DAYCARE, 1

	.DB 1
	bg_event 17, 29, TEXT_ROUTE5_UNDERGROUND_PATH_SIGN

	.DB 0
	event_displacement ROUTE_5_WIDTH, 10, 29
	event_displacement ROUTE_5_WIDTH, 9, 29
	event_displacement ROUTE_5_WIDTH, 10, 33
	event_displacement ROUTE_5_WIDTH, 17, 27
	event_displacement ROUTE_5_WIDTH, 10, 21