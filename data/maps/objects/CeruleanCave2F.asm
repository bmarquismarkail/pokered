	object_const_def
	const_export CERULEANCAVE2F_PP_UP
	const_export CERULEANCAVE2F_ULTRA_BALL
	const_export CERULEANCAVE2F_FULL_RESTORE

CeruleanCave2F_Object:
	.DB $7d ; border block

	.DB 6
	warp_event 29,  1, CERULEAN_CAVE_1F, 3
	warp_event 22,  6, CERULEAN_CAVE_1F, 4
	warp_event 19,  7, CERULEAN_CAVE_1F, 5
	warp_event  9,  1, CERULEAN_CAVE_1F, 6
	warp_event  1,  3, CERULEAN_CAVE_1F, 7
	warp_event  3, 11, CERULEAN_CAVE_1F, 8

	.DB 0
	.DB 3
	object_event 29,  9, SPRITE_POKE_BALL, STAY, NONE, TEXT_CERULEANCAVE2F_PP_UP, PP_UP
	object_event  4, 15, SPRITE_POKE_BALL, STAY, NONE, TEXT_CERULEANCAVE2F_ULTRA_BALL, ULTRA_BALL
	object_event 13,  6, SPRITE_POKE_BALL, STAY, NONE, TEXT_CERULEANCAVE2F_FULL_RESTORE, FULL_RESTORE

	event_displacement CERULEAN_CAVE_2F_WIDTH, 29, 1

	event_displacement CERULEAN_CAVE_2F_WIDTH, 22, 6

	event_displacement CERULEAN_CAVE_2F_WIDTH, 19, 7

	event_displacement CERULEAN_CAVE_2F_WIDTH, 9, 1

	event_displacement CERULEAN_CAVE_2F_WIDTH, 1, 3

	event_displacement CERULEAN_CAVE_2F_WIDTH, 3, 11