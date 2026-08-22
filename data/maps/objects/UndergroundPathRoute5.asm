	object_const_def
	const_export UNDERGROUNDPATHROUTE5_LITTLE_GIRL

UndergroundPathRoute5_Object:
	.DB $a ; border block

	.DB 3
	warp_event  3,  7, LAST_MAP, 4
	warp_event  4,  7, LAST_MAP, 4
	warp_event  4,  4, UNDERGROUND_PATH_NORTH_SOUTH, 1

	.DB 0
	.DB 1
	object_event  2,  3, SPRITE_LITTLE_GIRL, STAY, NONE, TEXT_UNDERGROUNDPATHROUTE5_LITTLE_GIRL

	event_displacement UNDERGROUND_PATH_ROUTE_5_WIDTH, 3, 7

	event_displacement UNDERGROUND_PATH_ROUTE_5_WIDTH, 4, 7

	event_displacement UNDERGROUND_PATH_ROUTE_5_WIDTH, 4, 4