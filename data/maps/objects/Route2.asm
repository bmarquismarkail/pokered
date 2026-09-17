	object_const_def
	const_export ROUTE2_MOON_STONE
	const_export ROUTE2_HP_UP

Route2_Object:
	.DB $f ; border block

	.DB 6
	warp_event 12,  9, DIGLETTS_CAVE_ROUTE_2, 1
	warp_event  3, 11, VIRIDIAN_FOREST_NORTH_GATE, 2
	warp_event 15, 19, ROUTE_2_TRADE_HOUSE, 1
	warp_event 16, 35, ROUTE_2_GATE, 2
	warp_event 15, 39, ROUTE_2_GATE, 3
	warp_event  3, 43, VIRIDIAN_FOREST_SOUTH_GATE, 3

	.DB 2
	bg_event  5, 65, TEXT_ROUTE2_SIGN
	bg_event 11, 11, TEXT_ROUTE2_DIGLETTS_CAVE_SIGN

	.DB 2
	object_event 13, 54, SPRITE_POKE_BALL, STAY, NONE, TEXT_ROUTE2_MOON_STONE, MOON_STONE
	object_event 13, 45, SPRITE_POKE_BALL, STAY, NONE, TEXT_ROUTE2_HP_UP, HP_UP

	event_displacement ROUTE_2_WIDTH, 12, 9

	event_displacement ROUTE_2_WIDTH, 3, 11

	event_displacement ROUTE_2_WIDTH, 15, 19

	event_displacement ROUTE_2_WIDTH, 16, 35

	event_displacement ROUTE_2_WIDTH, 15, 39

	event_displacement ROUTE_2_WIDTH, 3, 43
	; unused
	warp_to 2, 7, 4
	.DB $12, $c7, $9, $7
	warp_to 2, 7, 4
	warp_to 2, 7, 4
	warp_to 2, 7, 4
