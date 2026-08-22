	object_const_def
	const_export ROUTE15GATE2F_OAKS_AIDE

Route15Gate2F_Object:
	.DB $a ; border block

	.DB 1
	warp_event  7,  7, ROUTE_15_GATE_1F, 5

	.DB 1
	bg_event  6,  2, TEXT_ROUTE15GATE2F_BINOCULARS

	.DB 1
	object_event  4,  2, SPRITE_SCIENTIST, STAY, DOWN, TEXT_ROUTE15GATE2F_OAKS_AIDE

	event_displacement ROUTE_15_GATE_2F_WIDTH, 7, 7