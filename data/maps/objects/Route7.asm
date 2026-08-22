Route7_Object:
	.DB $f ; border block

	.DB 5
	warp_event 18,  9, ROUTE_7_GATE, 3
	warp_event 18, 10, ROUTE_7_GATE, 4
	warp_event 11,  9, ROUTE_7_GATE, 1
	warp_event 11, 10, ROUTE_7_GATE, 2
	warp_event  5, 13, UNDERGROUND_PATH_ROUTE_7, 1

	.DB 1
	bg_event  3, 13, TEXT_ROUTE7_UNDERGROUND_PATH_SIGN

	.DB 0
	event_displacement ROUTE_7_WIDTH, 18, 9
	event_displacement ROUTE_7_WIDTH, 18, 10
	event_displacement ROUTE_7_WIDTH, 11, 9
	event_displacement ROUTE_7_WIDTH, 11, 10
	event_displacement ROUTE_7_WIDTH, 5, 13