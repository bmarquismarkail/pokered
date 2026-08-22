	object_const_def
	const_export ROUTE6GATE_GUARD

Route6Gate_Object:
	.DB $a ; border block

	.DB 4
	warp_event  3,  5, LAST_MAP, 3
	warp_event  4,  5, LAST_MAP, 3
	warp_event  3,  0, LAST_MAP, 2
	warp_event  4,  0, LAST_MAP, 2

	.DB 0
	.DB 1
	object_event  6,  2, SPRITE_GUARD, STAY, LEFT, TEXT_ROUTE6GATE_GUARD

	event_displacement ROUTE_6_GATE_WIDTH, 3, 5

	event_displacement ROUTE_6_GATE_WIDTH, 4, 5

	event_displacement ROUTE_6_GATE_WIDTH, 3, 0

	event_displacement ROUTE_6_GATE_WIDTH, 4, 0