	object_const_def
	const_export MUSEUM1F_SCIENTIST1
	const_export MUSEUM1F_GAMBLER
	const_export MUSEUM1F_SCIENTIST2
	const_export MUSEUM1F_SCIENTIST3
	const_export MUSEUM1F_OLD_AMBER

Museum1F_Object:
	.DB $a ; border block

	.DB 5
	warp_event 10,  7, LAST_MAP, 1
	warp_event 11,  7, LAST_MAP, 1
	warp_event 16,  7, LAST_MAP, 2
	warp_event 17,  7, LAST_MAP, 2
	warp_event  7,  7, MUSEUM_2F, 1

	.DB 0
	.DB 5
	object_event 12,  4, SPRITE_SCIENTIST, STAY, LEFT, TEXT_MUSEUM1F_SCIENTIST1
	object_event  1,  4, SPRITE_GAMBLER, STAY, NONE, TEXT_MUSEUM1F_GAMBLER
	object_event 15,  2, SPRITE_SCIENTIST, STAY, DOWN, TEXT_MUSEUM1F_SCIENTIST2
	object_event 17,  4, SPRITE_SCIENTIST, STAY, NONE, TEXT_MUSEUM1F_SCIENTIST3
	object_event 16,  2, SPRITE_OLD_AMBER, STAY, NONE, TEXT_MUSEUM1F_OLD_AMBER

	event_displacement MUSEUM_1F_WIDTH, 10, 7

	event_displacement MUSEUM_1F_WIDTH, 11, 7

	event_displacement MUSEUM_1F_WIDTH, 16, 7

	event_displacement MUSEUM_1F_WIDTH, 17, 7

	event_displacement MUSEUM_1F_WIDTH, 7, 7