	object_const_def
	const_export CERULEANCAVE1F_FULL_RESTORE
	const_export CERULEANCAVE1F_MAX_ELIXER
	const_export CERULEANCAVE1F_NUGGET

CeruleanCave1F_Object:
	.DB $7d ; border block

	.DB 9
	warp_event 24, 17, LAST_MAP, 7
	warp_event 25, 17, LAST_MAP, 7
	warp_event 27,  1, CERULEAN_CAVE_2F, 1
	warp_event 23,  7, CERULEAN_CAVE_2F, 2
	warp_event 18,  9, CERULEAN_CAVE_2F, 3
	warp_event  7,  1, CERULEAN_CAVE_2F, 4
	warp_event  1,  3, CERULEAN_CAVE_2F, 5
	warp_event  3, 11, CERULEAN_CAVE_2F, 6
	warp_event  0,  6, CERULEAN_CAVE_B1F, 1

	.DB 0
	.DB 3
	object_event  7, 13, SPRITE_POKE_BALL, STAY, NONE, TEXT_CERULEANCAVE1F_FULL_RESTORE, FULL_RESTORE
	object_event 19,  3, SPRITE_POKE_BALL, STAY, NONE, TEXT_CERULEANCAVE1F_MAX_ELIXER, MAX_ELIXER
	object_event  5,  0, SPRITE_POKE_BALL, STAY, NONE, TEXT_CERULEANCAVE1F_NUGGET, NUGGET

	event_displacement CERULEAN_CAVE_1F_WIDTH, 24, 17

	event_displacement CERULEAN_CAVE_1F_WIDTH, 25, 17

	event_displacement CERULEAN_CAVE_1F_WIDTH, 27, 1

	event_displacement CERULEAN_CAVE_1F_WIDTH, 23, 7

	event_displacement CERULEAN_CAVE_1F_WIDTH, 18, 9

	event_displacement CERULEAN_CAVE_1F_WIDTH, 7, 1

	event_displacement CERULEAN_CAVE_1F_WIDTH, 1, 3

	event_displacement CERULEAN_CAVE_1F_WIDTH, 3, 11

	event_displacement CERULEAN_CAVE_1F_WIDTH, 0, 6