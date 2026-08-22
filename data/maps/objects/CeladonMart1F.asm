	object_const_def
	const_export CELADONMART1F_RECEPTIONIST

CeladonMart1F_Object:
	.DB $f ; border block

	.DB 6
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1
	warp_event 16,  7, LAST_MAP, 2
	warp_event 17,  7, LAST_MAP, 2
	warp_event 12,  1, CELADON_MART_2F, 1
	warp_event  1,  1, CELADON_MART_ELEVATOR, 1

	.DB 2
	bg_event 11,  4, TEXT_CELADONMART1F_DIRECTORY_SIGN
	bg_event 14,  1, TEXT_CELADONMART1F_CURRENT_FLOOR_SIGN

	.DB 1
	object_event  8,  3, SPRITE_LINK_RECEPTIONIST, STAY, DOWN, TEXT_CELADONMART1F_RECEPTIONIST

	event_displacement CELADON_MART_1F_WIDTH, 2, 7

	event_displacement CELADON_MART_1F_WIDTH, 3, 7

	event_displacement CELADON_MART_1F_WIDTH, 16, 7

	event_displacement CELADON_MART_1F_WIDTH, 17, 7

	event_displacement CELADON_MART_1F_WIDTH, 12, 1

	event_displacement CELADON_MART_1F_WIDTH, 1, 1