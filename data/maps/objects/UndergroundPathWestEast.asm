UndergroundPathWestEast_Object:
	.DB $1 ; border block

	.DB 2
	warp_event  2,  5, UNDERGROUND_PATH_ROUTE_7, 3
	warp_event 47,  2, UNDERGROUND_PATH_ROUTE_8, 3

	.DB 0
	.DB 0
	event_displacement UNDERGROUND_PATH_WEST_EAST_WIDTH, 2, 5
	event_displacement UNDERGROUND_PATH_WEST_EAST_WIDTH, 47, 2