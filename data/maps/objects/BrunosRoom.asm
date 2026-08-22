	object_const_def
	const_export BRUNOSROOM_BRUNO

BrunosRoom_Object:
	.DB $3 ; border block

	.DB 4
	warp_event  4, 11, LORELEIS_ROOM, 3
	warp_event  5, 11, LORELEIS_ROOM, 4
	warp_event  4,  0, AGATHAS_ROOM, 1
	warp_event  5,  0, AGATHAS_ROOM, 2

	.DB 0
	.DB 1
	object_event  5,  2, SPRITE_BRUNO, STAY, DOWN, TEXT_BRUNOSROOM_BRUNO, OPP_BRUNO, 1

	event_displacement BRUNOS_ROOM_WIDTH, 4, 11

	event_displacement BRUNOS_ROOM_WIDTH, 5, 11

	event_displacement BRUNOS_ROOM_WIDTH, 4, 0

	event_displacement BRUNOS_ROOM_WIDTH, 5, 0