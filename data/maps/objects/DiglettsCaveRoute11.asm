	object_const_def
	const_export DIGLETTSCAVEROUTE11_GAMBLER

DiglettsCaveRoute11_Object:
	.DB $7d ; border block

	.DB 3
	warp_event  2,  7, LAST_MAP, 5
	warp_event  3,  7, LAST_MAP, 5
	warp_event  4,  4, DIGLETTS_CAVE, 2

	.DB 0
	.DB 1
	object_event  2,  3, SPRITE_GAMBLER, STAY, NONE, TEXT_DIGLETTSCAVEROUTE11_GAMBLER

	event_displacement DIGLETTS_CAVE_ROUTE_11_WIDTH, 2, 7

	event_displacement DIGLETTS_CAVE_ROUTE_11_WIDTH, 3, 7

	event_displacement DIGLETTS_CAVE_ROUTE_11_WIDTH, 4, 4