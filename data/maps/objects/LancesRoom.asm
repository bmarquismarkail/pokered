	object_const_def
	const_export LANCESROOM_LANCE

LancesRoom_Object:
	.DB $3 ; border block

	.DB 3
	warp_event 24, 16, AGATHAS_ROOM, 3
	warp_event  5,  0, CHAMPIONS_ROOM, 1
	warp_event  6,  0, CHAMPIONS_ROOM, 1

	.DB 0
	.DB 1
	object_event  6,  1, SPRITE_LANCE, STAY, DOWN, TEXT_LANCESROOM_LANCE, OPP_LANCE, 1

	event_displacement LANCES_ROOM_WIDTH, 24, 16

	event_displacement LANCES_ROOM_WIDTH, 5, 0

	event_displacement LANCES_ROOM_WIDTH, 6, 0