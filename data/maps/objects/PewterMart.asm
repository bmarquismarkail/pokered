	object_const_def
	const_export PEWTERMART_CLERK
	const_export PEWTERMART_YOUNGSTER
	const_export PEWTERMART_SUPER_NERD

PewterMart_Object:
	.DB $0 ; border block

	.DB 2
	warp_event  3,  7, LAST_MAP, 5
	warp_event  4,  7, LAST_MAP, 5

	.DB 0
	.DB 3
	object_event  0,  5, SPRITE_CLERK, STAY, RIGHT, TEXT_PEWTERMART_CLERK
	object_event  3,  3, SPRITE_YOUNGSTER, WALK, UP_DOWN, TEXT_PEWTERMART_YOUNGSTER
	object_event  5,  5, SPRITE_SUPER_NERD, STAY, NONE, TEXT_PEWTERMART_SUPER_NERD

	event_displacement PEWTER_MART_WIDTH, 3, 7

	event_displacement PEWTER_MART_WIDTH, 4, 7