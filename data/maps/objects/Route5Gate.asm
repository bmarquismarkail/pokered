	object_const_def
	const_export ROUTE5GATE_GUARD

Route5Gate_Object:
	.DB $a ; border block

	.DB 4
	warp_event  3,  5, LAST_MAP, 3
	warp_event  4,  5, LAST_MAP, 3
	warp_event  3,  0, LAST_MAP, 2
	warp_event  4,  0, LAST_MAP, 1

	.DB 0
	.DB 1
	object_event  1,  3, SPRITE_GUARD, STAY, RIGHT, TEXT_ROUTE5GATE_GUARD

	event_displacement ROUTE_5_GATE_WIDTH, 3, 5

	event_displacement ROUTE_5_GATE_WIDTH, 4, 5

	event_displacement ROUTE_5_GATE_WIDTH, 3, 0

	event_displacement ROUTE_5_GATE_WIDTH, 4, 0