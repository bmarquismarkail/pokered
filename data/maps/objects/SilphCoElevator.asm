SilphCoElevator_Object:
	.DB $f ; border block

	.DB 2
	warp_event  1,  3, UNUSED_MAP_ED, 1
	warp_event  2,  3, UNUSED_MAP_ED, 1

	.DB 1
	bg_event  3,  0, TEXT_SILPHCOELEVATOR_ELEVATOR

	.DB 0
	event_displacement SILPH_CO_ELEVATOR_WIDTH, 1, 3
	event_displacement SILPH_CO_ELEVATOR_WIDTH, 2, 3