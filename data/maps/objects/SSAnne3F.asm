	object_const_def
	const_export SSANNE3F_SAILOR

SSAnne3F_Object:
	.DB $c ; border block

	.DB 2
	warp_event  0,  3, SS_ANNE_BOW, 1
	warp_event 19,  3, SS_ANNE_2F, 8

	.DB 0
	.DB 1
	object_event  9,  3, SPRITE_SAILOR, WALK, LEFT_RIGHT, TEXT_SSANNE3F_SAILOR

	event_displacement SS_ANNE_3F_WIDTH, 0, 3

	event_displacement SS_ANNE_3F_WIDTH, 19, 3