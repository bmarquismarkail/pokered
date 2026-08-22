	object_const_def
	const_export LORELEISROOM_LORELEI

LoreleisRoom_Object:
	.DB $3 ; border block

	.DB 4
	warp_event  4, 11, INDIGO_PLATEAU_LOBBY, 3
	warp_event  5, 11, INDIGO_PLATEAU_LOBBY, 3
	warp_event  4,  0, BRUNOS_ROOM, 1
	warp_event  5,  0, BRUNOS_ROOM, 2

	.DB 0
	.DB 1
	object_event  5,  2, SPRITE_LORELEI, STAY, DOWN, TEXT_LORELEISROOM_LORELEI, OPP_LORELEI, 1

	event_displacement LORELEIS_ROOM_WIDTH, 4, 11

	event_displacement LORELEIS_ROOM_WIDTH, 5, 11

	event_displacement LORELEIS_ROOM_WIDTH, 4, 0

	event_displacement LORELEIS_ROOM_WIDTH, 5, 0