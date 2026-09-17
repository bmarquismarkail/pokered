	object_const_def
	const_export ROUTE12GATE1F_GUARD

Route12Gate1F_Object:
	.DB $a ; border block

	.DB 5
	warp_event  4,  0, LAST_MAP, 1
	warp_event  5,  0, LAST_MAP, 2
	warp_event  4,  7, LAST_MAP, 3
	warp_event  5,  7, LAST_MAP, 3
	warp_event  8,  6, ROUTE_12_GATE_2F, 1

	.DB 0
	.DB 1
	object_event  1,  3, SPRITE_GUARD, STAY, NONE, TEXT_ROUTE12GATE1F_GUARD

	event_displacement ROUTE_12_GATE_1F_WIDTH, 4, 0

	event_displacement ROUTE_12_GATE_1F_WIDTH, 5, 0

	event_displacement ROUTE_12_GATE_1F_WIDTH, 4, 7

	event_displacement ROUTE_12_GATE_1F_WIDTH, 5, 7

	event_displacement ROUTE_12_GATE_1F_WIDTH, 8, 6