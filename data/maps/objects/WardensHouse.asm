	object_const_def
	const_export WARDENSHOUSE_WARDEN
	const_export WARDENSHOUSE_RARE_CANDY
	const_export WARDENSHOUSE_BOULDER

WardensHouse_Object:
	.DB $17 ; border block

	.DB 2
	warp_event  4,  7, LAST_MAP, 4
	warp_event  5,  7, LAST_MAP, 4

	.DB 2
	bg_event  4,  3, TEXT_WARDENSHOUSE_DISPLAY_LEFT
	bg_event  5,  3, TEXT_WARDENSHOUSE_DISPLAY_RIGHT

	.DB 3
	object_event  2,  3, SPRITE_WARDEN, STAY, NONE, TEXT_WARDENSHOUSE_WARDEN
	object_event  8,  3, SPRITE_POKE_BALL, STAY, NONE, TEXT_WARDENSHOUSE_RARE_CANDY, RARE_CANDY
	object_event  8,  4, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, TEXT_WARDENSHOUSE_BOULDER

	event_displacement WARDENS_HOUSE_WIDTH, 4, 7

	event_displacement WARDENS_HOUSE_WIDTH, 5, 7