	object_const_def
	const_export DIGLETTSCAVEROUTE2_FISHING_GURU

DiglettsCaveRoute2_Object:
	.DB $7d ; border block

	.DB 3
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1
	warp_event  4,  4, DIGLETTS_CAVE, 1

	.DB 0
	.DB 1
	object_event  3,  3, SPRITE_FISHING_GURU, STAY, NONE, TEXT_DIGLETTSCAVEROUTE2_FISHING_GURU

	event_displacement DIGLETTS_CAVE_ROUTE_2_WIDTH, 2, 7

	event_displacement DIGLETTS_CAVE_ROUTE_2_WIDTH, 3, 7

	event_displacement DIGLETTS_CAVE_ROUTE_2_WIDTH, 4, 4