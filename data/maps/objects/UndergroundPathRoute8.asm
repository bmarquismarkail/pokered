	object_const_def
	const_export UNDERGROUNDPATHROUTE8_GIRL

UndergroundPathRoute8_Object:
	.DB $a ; border block

	.DB 3
	warp_event  3,  7, LAST_MAP, 5
	warp_event  4,  7, LAST_MAP, 5
	warp_event  4,  4, UNDERGROUND_PATH_WEST_EAST, 2

	.DB 0
	.DB 1
	object_event  3,  4, SPRITE_GIRL, STAY, NONE, TEXT_UNDERGROUNDPATHROUTE8_GIRL

	event_displacement UNDERGROUND_PATH_ROUTE_8_WIDTH, 3, 7

	event_displacement UNDERGROUND_PATH_ROUTE_8_WIDTH, 4, 7

	event_displacement UNDERGROUND_PATH_ROUTE_8_WIDTH, 4, 4