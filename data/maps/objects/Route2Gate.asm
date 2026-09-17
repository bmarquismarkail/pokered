	object_const_def
	const_export ROUTE2GATE_OAKS_AIDE
	const_export ROUTE2GATE_YOUNGSTER

Route2Gate_Object:
	.DB $a ; border block

	.DB 4
	warp_event  4,  0, LAST_MAP, 4
	warp_event  5,  0, LAST_MAP, 4
	warp_event  4,  7, LAST_MAP, 5
	warp_event  5,  7, LAST_MAP, 5

	.DB 0
	.DB 2
	object_event  1,  4, SPRITE_SCIENTIST, STAY, LEFT, TEXT_ROUTE2GATE_OAKS_AIDE
	object_event  5,  4, SPRITE_YOUNGSTER, WALK, LEFT_RIGHT, TEXT_ROUTE2GATE_YOUNGSTER

	event_displacement ROUTE_2_GATE_WIDTH, 4, 0

	event_displacement ROUTE_2_GATE_WIDTH, 5, 0

	event_displacement ROUTE_2_GATE_WIDTH, 4, 7

	event_displacement ROUTE_2_GATE_WIDTH, 5, 7