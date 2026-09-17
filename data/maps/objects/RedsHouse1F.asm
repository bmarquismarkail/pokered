	object_const_def
	const_export REDSHOUSE1F_MOM

RedsHouse1F_Object:
	.DB $a ; border block

	.DB 3
	warp_event  2,  7, LAST_MAP, 1
	warp_event  3,  7, LAST_MAP, 1
	warp_event  7,  1, REDS_HOUSE_2F, 1

	.DB 1
	bg_event  3,  1, TEXT_REDSHOUSE1F_TV

	.DB 1
	object_event  5,  4, SPRITE_MOM, STAY, LEFT, TEXT_REDSHOUSE1F_MOM

	event_displacement REDS_HOUSE_1F_WIDTH, 2, 7

	event_displacement REDS_HOUSE_1F_WIDTH, 3, 7

	event_displacement REDS_HOUSE_1F_WIDTH, 7, 1