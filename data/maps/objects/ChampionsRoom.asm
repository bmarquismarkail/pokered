	object_const_def
	const_export CHAMPIONSROOM_RIVAL
	const_export CHAMPIONSROOM_OAK

ChampionsRoom_Object:
	.DB $3 ; border block

	.DB 4
	warp_event  3,  7, LANCES_ROOM, 2
	warp_event  4,  7, LANCES_ROOM, 3
	warp_event  3,  0, HALL_OF_FAME, 1
	warp_event  4,  0, HALL_OF_FAME, 1

	.DB 0
	.DB 2
	object_event  4,  2, SPRITE_BLUE, STAY, DOWN, TEXT_CHAMPIONSROOM_RIVAL
	object_event  3,  7, SPRITE_OAK, STAY, UP, TEXT_CHAMPIONSROOM_OAK

	event_displacement CHAMPIONS_ROOM_WIDTH, 3, 7

	event_displacement CHAMPIONS_ROOM_WIDTH, 4, 7

	event_displacement CHAMPIONS_ROOM_WIDTH, 3, 0

	event_displacement CHAMPIONS_ROOM_WIDTH, 4, 0