	object_const_def
	const_export HALLOFFAME_OAK

HallOfFame_Object:
	.DB $3 ; border block

	.DB 2
	warp_event  4,  7, CHAMPIONS_ROOM, 3
	warp_event  5,  7, CHAMPIONS_ROOM, 4

	.DB 0
	.DB 1
	object_event  5,  2, SPRITE_OAK, STAY, DOWN, TEXT_HALLOFFAME_OAK

	event_displacement HALL_OF_FAME_WIDTH, 4, 7

	event_displacement HALL_OF_FAME_WIDTH, 5, 7