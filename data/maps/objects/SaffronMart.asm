	object_const_def
	const_export SAFFRONMART_CLERK
	const_export SAFFRONMART_SUPER_NERD
	const_export SAFFRONMART_COOLTRAINER_F

SaffronMart_Object:
	.DB $0 ; border block

	.DB 2
	warp_event  3,  7, LAST_MAP, 5
	warp_event  4,  7, LAST_MAP, 5

	.DB 0
	.DB 3
	object_event  0,  5, SPRITE_CLERK, STAY, RIGHT, TEXT_SAFFRONMART_CLERK
	object_event  4,  2, SPRITE_SUPER_NERD, STAY, NONE, TEXT_SAFFRONMART_SUPER_NERD
	object_event  6,  5, SPRITE_COOLTRAINER_F, WALK, ANY_DIR, TEXT_SAFFRONMART_COOLTRAINER_F

	event_displacement SAFFRON_MART_WIDTH, 3, 7

	event_displacement SAFFRON_MART_WIDTH, 4, 7