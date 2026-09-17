	object_const_def
	const_export CERULEANTRASHEDHOUSE_FISHING_GURU
	const_export CERULEANTRASHEDHOUSE_GIRL

CeruleanTrashedHouse_Object:
	.DB $a ; border block

	.DB 3
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1
	warp_event  3,  0, LAST_MAP, 8

	.DB 1
	bg_event  3,  0, TEXT_CERULEANTRASHEDHOUSE_WALL_HOLE

	.DB 2
	object_event  2,  1, SPRITE_FISHING_GURU, STAY, DOWN, TEXT_CERULEANTRASHEDHOUSE_FISHING_GURU
	object_event  5,  6, SPRITE_GIRL, WALK, LEFT_RIGHT, TEXT_CERULEANTRASHEDHOUSE_GIRL

	event_displacement CERULEAN_TRASHED_HOUSE_WIDTH, 2, 7

	event_displacement CERULEAN_TRASHED_HOUSE_WIDTH, 3, 7

	event_displacement CERULEAN_TRASHED_HOUSE_WIDTH, 3, 0