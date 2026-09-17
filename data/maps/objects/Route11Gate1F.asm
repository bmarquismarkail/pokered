	object_const_def
	const_export ROUTE11GATE1F_GUARD

Route11Gate1F_Object:
	.DB $a ; border block

	.DB 5
	warp_event  0,  4, LAST_MAP, 1
	warp_event  0,  5, LAST_MAP, 2
	warp_event  7,  4, LAST_MAP, 3
	warp_event  7,  5, LAST_MAP, 4
	warp_event  6,  8, ROUTE_11_GATE_2F, 1

	.DB 0
	.DB 1
	object_event  4,  1, SPRITE_GUARD, STAY, NONE, TEXT_ROUTE11GATE1F_GUARD

	event_displacement ROUTE_11_GATE_1F_WIDTH, 0, 4

	event_displacement ROUTE_11_GATE_1F_WIDTH, 0, 5

	event_displacement ROUTE_11_GATE_1F_WIDTH, 7, 4

	event_displacement ROUTE_11_GATE_1F_WIDTH, 7, 5

	event_displacement ROUTE_11_GATE_1F_WIDTH, 6, 8