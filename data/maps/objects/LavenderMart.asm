	object_const_def
	const_export LAVENDERMART_CLERK
	const_export LAVENDERMART_BALDING_GUY
	const_export LAVENDERMART_COOLTRAINER_M

LavenderMart_Object:
	.DB $0 ; border block

	.DB 2
	warp_event  3,  7, LAST_MAP, 4
	warp_event  4,  7, LAST_MAP, 4

	.DB 0
	.DB 3
	object_event  0,  5, SPRITE_CLERK, STAY, RIGHT, TEXT_LAVENDERMART_CLERK
	object_event  3,  4, SPRITE_BALDING_GUY, STAY, NONE, TEXT_LAVENDERMART_BALDING_GUY
	object_event  7,  2, SPRITE_COOLTRAINER_M, STAY, NONE, TEXT_LAVENDERMART_COOLTRAINER_M

	event_displacement LAVENDER_MART_WIDTH, 3, 7

	event_displacement LAVENDER_MART_WIDTH, 4, 7