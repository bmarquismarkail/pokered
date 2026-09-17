UndergroundPathNorthSouth_Object:
	.DB $1 ; border block

	.DB 2
	warp_event  5,  4, UNDERGROUND_PATH_ROUTE_5, 3
	warp_event  2, 41, UNDERGROUND_PATH_ROUTE_6, 3

	.DB 0
	.DB 0
	event_displacement UNDERGROUND_PATH_NORTH_SOUTH_WIDTH, 5, 4
	event_displacement UNDERGROUND_PATH_NORTH_SOUTH_WIDTH, 2, 41