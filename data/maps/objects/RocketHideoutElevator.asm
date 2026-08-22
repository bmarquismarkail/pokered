RocketHideoutElevator_Object:
	.DB $f ; border block

	.DB 2
	warp_event  2,  1, ROCKET_HIDEOUT_B1F, 3
	warp_event  3,  1, ROCKET_HIDEOUT_B1F, 5

	.DB 1
	bg_event  1,  1, TEXT_ROCKETHIDEOUTELEVATOR

	.DB 0
	event_displacement ROCKET_HIDEOUT_ELEVATOR_WIDTH, 2, 1
	event_displacement ROCKET_HIDEOUT_ELEVATOR_WIDTH, 3, 1