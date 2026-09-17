DiglettsCave_Object:
	.DB $19 ; border block

	.DB 2
	warp_event  5,  5, DIGLETTS_CAVE_ROUTE_2, 3
	warp_event 37, 31, DIGLETTS_CAVE_ROUTE_11, 3

	.DB 0
	.DB 0
	event_displacement DIGLETTS_CAVE_WIDTH, 5, 5
	event_displacement DIGLETTS_CAVE_WIDTH, 37, 31