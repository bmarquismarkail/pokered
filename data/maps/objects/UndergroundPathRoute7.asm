	object_const_def
	const_export UNDERGROUNDPATHROUTE7_MIDDLE_AGED_MAN

UndergroundPathRoute7_Object:
	.DB $a ; border block

	.DB 3
	warp_event  3,  7, LAST_MAP, 5
	warp_event  4,  7, LAST_MAP, 5
	warp_event  4,  4, UNDERGROUND_PATH_WEST_EAST, 1

	.DB 0
	.DB 1
	object_event  2,  4, SPRITE_MIDDLE_AGED_MAN, STAY, NONE, TEXT_UNDERGROUNDPATHROUTE7_MIDDLE_AGED_MAN

	event_displacement UNDERGROUND_PATH_ROUTE_7_WIDTH, 3, 7

	event_displacement UNDERGROUND_PATH_ROUTE_7_WIDTH, 4, 7

	event_displacement UNDERGROUND_PATH_ROUTE_7_WIDTH, 4, 4