	object_const_def
	const_export AGATHASROOM_AGATHA

AgathasRoom_Object:
	.DB $0 ; border block

	.DB 4
	warp_event  4, 11, BRUNOS_ROOM, 3
	warp_event  5, 11, BRUNOS_ROOM, 4
	warp_event  4,  0, LANCES_ROOM, 1
	warp_event  5,  0, LANCES_ROOM, 1

	.DB 0
	.DB 1
	object_event  5,  2, SPRITE_AGATHA, STAY, DOWN, TEXT_AGATHASROOM_AGATHA, OPP_AGATHA, 1

	event_displacement AGATHAS_ROOM_WIDTH, 4, 11

	event_displacement AGATHAS_ROOM_WIDTH, 5, 11

	event_displacement AGATHAS_ROOM_WIDTH, 4, 0

	event_displacement AGATHAS_ROOM_WIDTH, 5, 0