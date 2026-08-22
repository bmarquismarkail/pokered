	object_const_def
	const_export VIRIDIANMART_CLERK
	const_export VIRIDIANMART_YOUNGSTER
	const_export VIRIDIANMART_COOLTRAINER_M

ViridianMart_Object:
	.DB $0 ; border block

	.DB 2
	warp_event  3,  7, LAST_MAP, 2
	warp_event  4,  7, LAST_MAP, 2

	.DB 0
	.DB 3
	object_event  0,  5, SPRITE_CLERK, STAY, RIGHT, TEXT_VIRIDIANMART_CLERK
	object_event  5,  5, SPRITE_YOUNGSTER, WALK, UP_DOWN, TEXT_VIRIDIANMART_YOUNGSTER
	object_event  3,  3, SPRITE_COOLTRAINER_M, STAY, NONE, TEXT_VIRIDIANMART_COOLTRAINER_M

	event_displacement VIRIDIAN_MART_WIDTH, 3, 7

	event_displacement VIRIDIAN_MART_WIDTH, 4, 7