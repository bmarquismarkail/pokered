	object_const_def
	const_export ROUTE18GATE2F_YOUNGSTER

Route18Gate2F_Object:
	.DB $a ; border block

	.DB 1
	warp_event  7,  7, ROUTE_18_GATE_1F, 5

	.DB 2
	bg_event  1,  2, TEXT_ROUTE18GATE2F_LEFT_BINOCULARS
	bg_event  6,  2, TEXT_ROUTE18GATE2F_RIGHT_BINOCULARS

	.DB 1
	object_event  4,  2, SPRITE_YOUNGSTER, WALK, LEFT_RIGHT, TEXT_ROUTE18GATE2F_YOUNGSTER

	event_displacement ROUTE_18_GATE_2F_WIDTH, 7, 7