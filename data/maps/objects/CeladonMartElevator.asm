CeladonMartElevator_Object:
	.DB $f ; border block

	.DB 2
	warp_event  1,  3, CELADON_MART_1F, 6
	warp_event  2,  3, CELADON_MART_1F, 6

	.DB 1
	bg_event  3,  0, TEXT_CELADONMARTELEVATOR

	.DB 0
	event_displacement CELADON_MART_ELEVATOR_WIDTH, 1, 3
	event_displacement CELADON_MART_ELEVATOR_WIDTH, 2, 3