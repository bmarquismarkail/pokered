	object_const_def
	const_export ROUTE8GATE_GUARD

Route8Gate_Object:
	.DB $a ; border block

	.DB 4
	warp_event  0,  3, LAST_MAP, 1
	warp_event  0,  4, LAST_MAP, 2
	warp_event  5,  3, LAST_MAP, 3
	warp_event  5,  4, LAST_MAP, 4

	.DB 0
	.DB 1
	object_event  2,  1, SPRITE_GUARD, STAY, DOWN, TEXT_ROUTE8GATE_GUARD

	event_displacement ROUTE_8_GATE_WIDTH, 0, 3

	event_displacement ROUTE_8_GATE_WIDTH, 0, 4

	event_displacement ROUTE_8_GATE_WIDTH, 5, 3

	event_displacement ROUTE_8_GATE_WIDTH, 5, 4