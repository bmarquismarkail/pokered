	object_const_def
	const_export SSANNE2F_WAITER
	const_export SSANNE2F_RIVAL

SSAnne2F_Object:
	.DB $c ; border block

	.DB 9
	warp_event  9, 11, SS_ANNE_2F_ROOMS, 1
	warp_event 13, 11, SS_ANNE_2F_ROOMS, 3
	warp_event 17, 11, SS_ANNE_2F_ROOMS, 5
	warp_event 21, 11, SS_ANNE_2F_ROOMS, 7
	warp_event 25, 11, SS_ANNE_2F_ROOMS, 9
	warp_event 29, 11, SS_ANNE_2F_ROOMS, 11
	warp_event  2,  4, SS_ANNE_1F, 9
	warp_event  2, 12, SS_ANNE_3F, 2
	warp_event 36,  4, SS_ANNE_CAPTAINS_ROOM, 1

	.DB 0
	.DB 2
	object_event  3,  7, SPRITE_WAITER, WALK, UP_DOWN, TEXT_SSANNE2F_WAITER
	object_event 36,  4, SPRITE_BLUE, STAY, DOWN, TEXT_SSANNE2F_RIVAL, OPP_RIVAL1, 1

	event_displacement SS_ANNE_2F_WIDTH, 9, 11

	event_displacement SS_ANNE_2F_WIDTH, 13, 11

	event_displacement SS_ANNE_2F_WIDTH, 17, 11

	event_displacement SS_ANNE_2F_WIDTH, 21, 11

	event_displacement SS_ANNE_2F_WIDTH, 25, 11

	event_displacement SS_ANNE_2F_WIDTH, 29, 11

	event_displacement SS_ANNE_2F_WIDTH, 2, 4

	event_displacement SS_ANNE_2F_WIDTH, 2, 12

	event_displacement SS_ANNE_2F_WIDTH, 36, 4