	object_const_def
	const_export ROUTE22GATE_GUARD

Route22Gate_Object:
	.DB $a ; border block

	.DB 4
	warp_event  4,  7, LAST_MAP, 1
	warp_event  5,  7, LAST_MAP, 1
	warp_event  4,  0, LAST_MAP, 1
	warp_event  5,  0, LAST_MAP, 2

	.DB 0
	.DB 1
	object_event  6,  2, SPRITE_GUARD, STAY, LEFT, TEXT_ROUTE22GATE_GUARD

	event_displacement ROUTE_22_GATE_WIDTH, 4, 7

	event_displacement ROUTE_22_GATE_WIDTH, 5, 7

	event_displacement ROUTE_22_GATE_WIDTH, 4, 0

	event_displacement ROUTE_22_GATE_WIDTH, 5, 0