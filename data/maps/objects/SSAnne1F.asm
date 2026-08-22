	object_const_def
	const_export SSANNE1F_WAITER
	const_export SSANNE1F_SAILOR

SSAnne1F_Object:
	.DB $c ; border block

	.DB 11
	warp_event 26,  0, VERMILION_DOCK, 2
	warp_event 27,  0, VERMILION_DOCK, 2
	warp_event 31,  8, SS_ANNE_1F_ROOMS, 1
	warp_event 23,  8, SS_ANNE_1F_ROOMS, 2
	warp_event 19,  8, SS_ANNE_1F_ROOMS, 3
	warp_event 15,  8, SS_ANNE_1F_ROOMS, 4
	warp_event 11,  8, SS_ANNE_1F_ROOMS, 5
	warp_event  7,  8, SS_ANNE_1F_ROOMS, 6
	warp_event  2,  6, SS_ANNE_2F, 7
	warp_event 37, 15, SS_ANNE_B1F, 6
	warp_event  3, 16, SS_ANNE_KITCHEN, 1

	.DB 0
	.DB 2
	object_event 12,  6, SPRITE_WAITER, WALK, LEFT_RIGHT, TEXT_SSANNE1F_WAITER
	object_event 27,  5, SPRITE_SAILOR, STAY, NONE, TEXT_SSANNE1F_SAILOR

	event_displacement SS_ANNE_1F_WIDTH, 26, 0

	event_displacement SS_ANNE_1F_WIDTH, 27, 0

	event_displacement SS_ANNE_1F_WIDTH, 31, 8

	event_displacement SS_ANNE_1F_WIDTH, 23, 8

	event_displacement SS_ANNE_1F_WIDTH, 19, 8

	event_displacement SS_ANNE_1F_WIDTH, 15, 8

	event_displacement SS_ANNE_1F_WIDTH, 11, 8

	event_displacement SS_ANNE_1F_WIDTH, 7, 8

	event_displacement SS_ANNE_1F_WIDTH, 2, 6

	event_displacement SS_ANNE_1F_WIDTH, 37, 15

	event_displacement SS_ANNE_1F_WIDTH, 3, 16