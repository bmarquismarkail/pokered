	object_const_def
	const_export CINNABARLAB_FISHING_GURU

CinnabarLab_Object:
	.DB $17 ; border block

	.DB 5
	warp_event  2,  7, LAST_MAP, 3
	warp_event  3,  7, LAST_MAP, 3
	warp_event  8,  4, CINNABAR_LAB_TRADE_ROOM, 1
	warp_event 12,  4, CINNABAR_LAB_METRONOME_ROOM, 1
	warp_event 16,  4, CINNABAR_LAB_FOSSIL_ROOM, 1

	.DB 4
	bg_event  3,  2, TEXT_CINNABARLAB_PHOTO
	bg_event  9,  4, TEXT_CINNABARLAB_MEETING_ROOM_SIGN
	bg_event 13,  4, TEXT_CINNABARLAB_R_AND_D_SIGN
	bg_event 17,  4, TEXT_CINNABARLAB_TESTING_ROOM_SIGN

	.DB 1
	object_event  1,  3, SPRITE_FISHING_GURU, STAY, NONE, TEXT_CINNABARLAB_FISHING_GURU

	event_displacement CINNABAR_LAB_WIDTH, 2, 7

	event_displacement CINNABAR_LAB_WIDTH, 3, 7

	event_displacement CINNABAR_LAB_WIDTH, 8, 4

	event_displacement CINNABAR_LAB_WIDTH, 12, 4

	event_displacement CINNABAR_LAB_WIDTH, 16, 4