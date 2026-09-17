	object_const_def
	const_export ROUTE16GATE1F_GUARD
	const_export ROUTE16GATE1F_GAMBLER

Route16Gate1F_Object:
	.DB $a ; border block

	.DB 9
	warp_event  0,  8, LAST_MAP, 1
	warp_event  0,  9, LAST_MAP, 2
	warp_event  7,  8, LAST_MAP, 3
	warp_event  7,  9, LAST_MAP, 3
	warp_event  0,  2, LAST_MAP, 5
	warp_event  0,  3, LAST_MAP, 6
	warp_event  7,  2, LAST_MAP, 7
	warp_event  7,  3, LAST_MAP, 8
	warp_event  6, 12, ROUTE_16_GATE_2F, 1

	.DB 0
	.DB 2
	object_event  4,  5, SPRITE_GUARD, STAY, DOWN, TEXT_ROUTE16GATE1F_GUARD
	object_event  4,  3, SPRITE_GAMBLER, STAY, NONE, TEXT_ROUTE16GATE1F_GAMBLER

	event_displacement ROUTE_16_GATE_1F_WIDTH, 0, 8

	event_displacement ROUTE_16_GATE_1F_WIDTH, 0, 9

	event_displacement ROUTE_16_GATE_1F_WIDTH, 7, 8

	event_displacement ROUTE_16_GATE_1F_WIDTH, 7, 9

	event_displacement ROUTE_16_GATE_1F_WIDTH, 0, 2

	event_displacement ROUTE_16_GATE_1F_WIDTH, 0, 3

	event_displacement ROUTE_16_GATE_1F_WIDTH, 7, 2

	event_displacement ROUTE_16_GATE_1F_WIDTH, 7, 3

	event_displacement ROUTE_16_GATE_1F_WIDTH, 6, 12