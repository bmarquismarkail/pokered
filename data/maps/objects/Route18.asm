	object_const_def
	const_export ROUTE18_COOLTRAINER_M1
	const_export ROUTE18_COOLTRAINER_M2
	const_export ROUTE18_COOLTRAINER_M3

Route18_Object:
	.DB $43 ; border block

	.DB 4
	warp_event 33,  8, ROUTE_18_GATE_1F, 1
	warp_event 33,  9, ROUTE_18_GATE_1F, 2
	warp_event 40,  8, ROUTE_18_GATE_1F, 3
	warp_event 40,  9, ROUTE_18_GATE_1F, 4

	.DB 2
	bg_event 43,  7, TEXT_ROUTE18_SIGN
	bg_event 33,  5, TEXT_ROUTE18_CYCLING_ROAD_SIGN

	.DB 3
	object_event 36, 11, SPRITE_COOLTRAINER_M, STAY, RIGHT, TEXT_ROUTE18_COOLTRAINER_M1, OPP_BIRD_KEEPER, 8
	object_event 40, 15, SPRITE_COOLTRAINER_M, STAY, LEFT, TEXT_ROUTE18_COOLTRAINER_M2, OPP_BIRD_KEEPER, 9
	object_event 42, 13, SPRITE_COOLTRAINER_M, STAY, LEFT, TEXT_ROUTE18_COOLTRAINER_M3, OPP_BIRD_KEEPER, 10

	event_displacement ROUTE_18_WIDTH, 33, 8

	event_displacement ROUTE_18_WIDTH, 33, 9

	event_displacement ROUTE_18_WIDTH, 40, 8

	event_displacement ROUTE_18_WIDTH, 40, 9