CeladonMansion2F_Object:
	.DB $f ; border block

	.DB 4
	warp_event  6,  1, CELADON_MANSION_3F, 1
	warp_event  7,  1, CELADON_MANSION_1F, 4
	warp_event  2,  1, CELADON_MANSION_1F, 5
	warp_event  4,  1, CELADON_MANSION_3F, 4

	.DB 1
	bg_event  4,  9, TEXT_CELADONMANSION2F_MEETING_ROOM_SIGN

	.DB 0
	event_displacement CELADON_MANSION_2F_WIDTH, 6, 1
	event_displacement CELADON_MANSION_2F_WIDTH, 7, 1
	event_displacement CELADON_MANSION_2F_WIDTH, 2, 1
	event_displacement CELADON_MANSION_2F_WIDTH, 4, 1